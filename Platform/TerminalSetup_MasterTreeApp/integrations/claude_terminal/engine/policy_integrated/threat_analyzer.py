"""
Enhanced threat analysis with stronger patterns and scoring
"""

import re
import time
import ipaddress
from typing import Dict, List

class ThreatAnalyzer:
    def __init__(self, config: dict, phase2_integration):
        self.config = config
        self.phase2 = phase2_integration

        # Enhanced malware indicators (regex-ready substrings)
        self.malware_indicators: List[str] = [
            r"powershell\s+-enc",
            r"certutil\s+-decode",
            r"bitsadmin\s+/transfer",
            r"wmic\s+process\s+call\s+create",
            r"curl.*\|.*sh",
            r"wget.*\|.*sh",
            r"powershell\s+-(command|c)\b",
            r"(?:^|[\s;])cmd(?:\.exe)?\s+/c\b",
        ]

        # Enhanced command patterns with explicit scores
        self.command_patterns: List[Dict] = [
            {
                "pattern": r"rm\s+-rf\s+(/|/etc|/usr|/bin|/sbin|/System|/Library)",
                "threat_level": "critical",
                "score": 1.0,
                "description": "Critical system destruction"
            },
            {
                "pattern": r"(curl|wget).*\|\s*(sh|bash|python|perl)",
                "threat_level": "critical",
                "score": 0.95,
                "description": "Remote script execution"
            },
            {
                "pattern": r"dd\s+(if|of)=.*(/dev/|/)",
                "threat_level": "critical",
                "score": 0.90,
                "description": "Disk overwrite operation"
            },
            {
                "pattern": r"(mkfs\.)|(\bfdisk\s+/dev/)",
                "threat_level": "critical",
                "score": 0.90,
                "description": "Filesystem formatting"
            },
            {
                "pattern": r"chmod\s+777\b.*",
                "threat_level": "high",
                "score": 0.70,
                "description": "Insecure permissions"
            },
            {
                "pattern": r"sudo.*passwd",
                "threat_level": "high",
                "score": 0.70,
                "description": "Password change attempt"
            },
            {
                "pattern": r"\bnc\s+-l\b.*\s-e\b",
                "threat_level": "high",
                "score": 0.60,
                "description": "Netcat backdoor"
            },
            {
                "pattern": r"python.*-c.*exec",
                "threat_level": "medium",
                "score": 0.40,
                "description": "Inline Python code execution"
            },
            {
                "pattern": r"base64\s+(-d|--decode)|base64.*decode",
                "threat_level": "medium",
                "score": 0.30,
                "description": "Base64 decoding (potential obfuscation)"
            },
        ]

    def analyze_threats(self, command: str, context: Dict) -> Dict:
        """Analyze command for threat indicators with enhanced scoring."""
        threats_detected: List[Dict] = []
        threat_score = 0.0

        # Malware indicators (regex search on full command)
        for indicator in self.malware_indicators:
            if re.search(indicator, command, re.IGNORECASE):
                threats_detected.append({
                    "type": "malware_indicator",
                    "indicator": indicator,
                    "severity": "high",
                    "description": f"Known malware pattern matched: {indicator}"
                })
                threat_score += 0.60

        # Explicit command patterns
        for pat in self.command_patterns:
            if re.search(pat["pattern"], command, re.IGNORECASE):
                threats_detected.append({
                    "type": "suspicious_pattern",
                    "pattern": pat["pattern"],
                    "severity": pat["threat_level"],
                    "description": pat["description"]
                })
                threat_score += float(pat.get("score", 0.0))

        # Network context
        source_ip = context.get("source_ip", "")
        if source_ip and not self._is_internal_ip(source_ip):
            threats_detected.append({
                "type": "external_source",
                "indicator": source_ip,
                "severity": "medium",
                "description": "Command originated from external (non-private) IP"
            })
            threat_score += 0.20

        # Time-of-day context (off-hours)
        hour = time.localtime().tm_hour
        if hour < 6 or hour > 22:
            threats_detected.append({
                "type": "off_hours",
                "severity": "low",
                "description": "Command executed during off-hours"
            })
            threat_score += 0.10

        # Normalize score and derive level
        threat_score = min(threat_score, 1.0)
        if threat_score >= 0.90:
            threat_level = "critical"
        elif threat_score >= 0.60:
            threat_level = "high"
        elif threat_score >= 0.30:
            threat_level = "medium"
        elif threat_score > 0.0:
            threat_level = "low"
        else:
            threat_level = "none"

        return {
            "threat_score": threat_score,
            "threat_level": threat_level,
            "threats_detected": threats_detected,
            "analysis_timestamp": time.time()
        }

    def _is_internal_ip(self, ip: str) -> bool:
        """Return True if IP is private/internal; False otherwise."""
        try:
            return ipaddress.ip_address(ip).is_private
        except Exception:
            return False
