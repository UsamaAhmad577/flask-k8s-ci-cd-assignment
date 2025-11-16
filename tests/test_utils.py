# tests/test_utils.py
import sys
import os
# Add parent directory to path to import utils
sys.path.insert(0, os.path.abspath(
    os.path.join(os.path.dirname(__file__), '..')))

from utils import calculate_sum  # noqa: E402


def test_calculate_sum():
    """Test the calculate_sum function with various inputs."""
    # Test with positive numbers
    assert calculate_sum(2, 3) == 5
    assert calculate_sum(10, 20) == 30

    # Test with zero
    assert calculate_sum(0, 5) == 5
    assert calculate_sum(5, 0) == 5

    # Test with negative numbers
    assert calculate_sum(-1, 1) == 0
    assert calculate_sum(-5, -3) == -8

    # Test with large numbers
    assert calculate_sum(100, 200) == 300
