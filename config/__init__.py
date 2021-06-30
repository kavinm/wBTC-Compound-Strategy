## Ideally, they have one file with the settings for the strat and deployment
## This file would allow them to configure so they can test, deploy and interact with the strategy

BADGER_DEV_MULTISIG = "0xb65cef03b9b89f99517643226d76e286ee999e77"

WANT = "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599"  ## wBTC
LP_COMPONENT = "0xccf4429db6322d5c611ee964527d42e5d685dd6a"  ## cWBTC
REWARD_TOKEN = "0xc00e94Cb662C3520282E6f5717214004A7f26888"  ## Compound

PROTECTED_TOKENS = [WANT, LP_COMPONENT, REWARD_TOKEN]
## Fees in Basis Points
DEFAULT_GOV_PERFORMANCE_FEE = 1000
DEFAULT_PERFORMANCE_FEE = 1000
DEFAULT_WITHDRAWAL_FEE = 75

FEES = [DEFAULT_GOV_PERFORMANCE_FEE, DEFAULT_PERFORMANCE_FEE, DEFAULT_WITHDRAWAL_FEE]
