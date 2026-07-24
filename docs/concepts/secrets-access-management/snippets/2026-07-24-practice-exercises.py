# last_verified: 2026-07-24 · Python n/a
#
# Practice: Secrets & Access Management exercises
# I wrote these snippets to practice the pattern of reading a secret
# from the environment and simulating a rotation call.

import os


def get_db_password():
    # Secrets should come from the environment, never hardcoded.
    # The first time I wrote this, I forgot the env-var check and
    # had to debug a NoneType error in production.
    password = os.environ.get("DB_PASSWORD")
    if not password:
        raise RuntimeError("DB_PASSWORD is not set")
    return password


def simulate_rotation(old_secret: str) -> str:
    # In real life this would call Vault or AWS Secrets Manager;
    # here I simulate the flow so I can see the code path.
    new_secret = old_secret + "-rotated"
    return new_secret


if __name__ == "__main__":
    os.environ["DB_PASSWORD"] = "practice-secret-123"
    current = get_db_password()
    print(f"Current password ends with: ...{current[-4:]}")
    rotated = simulate_rotation(current)
    print(f"Rotated password ends with: ...{rotated[-8:]}")
