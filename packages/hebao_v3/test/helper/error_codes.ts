export enum ErrorCodes {
  ZERO_ADDRESS = 104,
  INVALID_VALID_SINCE = 105,
  ZERO_TOKEN = 106,
  MASTER_COPY_ZERO_ADDRESS = 107,

  BATCHED_CALL_FAILED = 300,
  DISALLOWED_ON_IMPLEMENTATION_CONTRACT = 301,
  NOT_ALLOWED_TO_SET_OWNER = 302,
  ONLY_FROM_ENTRYPOINT = 303,
  NOT_OWNER_SELF_OR_ENTRYPOINT_OR_LOCKED = 304,
  INVALID_OWNER = 305,
  INITIALIZED_ALREADY = 306,
  INVALID_SAME_ENTRYPOINT = 307,
  NOT_ENTRYPOINT_OR_INHERITOR = 308,
  NOT_EXECUTOR = 309,
  OFFICIALGUARDIAN_CALL_FAILED = 310,
  NOT_FROM_BALANCER_VAULT = 311,
  INVALID_SAME_MASTER_COPY = 312,
  MEMORY_NOT_MASTER = 313,

  NO_GUARDIANS = 400,
  INVALID_SIGNERS_ORDER = 401,
  SIGNER_NOT_GUARDIAN = 402,
  WALLET_OWNER_SIGNATURE_NOT_ALLOWED = 403,
  WALLET_OWNER_SIGNATURE_REQUIRED = 404,
  INVALID_ORDERING = 405,
  NO_GUARDIAN_SIGNED_BESIDES_OWNER = 406,
  INVALID_GUARDIAN_ADDRESS = 407,
  NOT_FROM_WALLET_OR_OWNER_OR_GUARDIAN = 408,
  QUOTA_EXCEEDED = 409,
  INVALID_QUOTA = 410,
  IS_SAME_OWNER = 411,
  INVALID_NEW_WALLET_OWNER = 412,
  INVALID_NEW_WALLET_GUARDIAN = 413,
  UNEXPECTED_RESULT = 414,
  INVALID_VALID_UNTIL = 415,
  GUARDIAN_NOT_EXISTS = 416,
  TOO_MANY_GUARDIANS = 417,
  GUARDIAN_CAN_NOT_BE_OWNER = 418,
  INVALID_MASTER_COPY = 419
}