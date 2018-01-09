use Mix.Config

config :phxdemo,
  ecto_repos: [Phxdemo.Repo],
  secret: "vVLgWXZ24ycJ8qtZvQL/KH0o0Qb15OUmgsFYryOMkYMsnKfjMvnOcJgIjnbIQsBOA2wXRDmuAT4PD4cKoTkBOxrWc309s1Gh9dmqZd7PXY0lfphiIxzyzj/Ko4fxNjTMij9LYNrPwv9uABC3kumuV3bkd42zi84dGdAnTFRDpT9AuVP773nupwJJXuRDCFL41SHylpbns8Aua8FwR3GDj1cb0pplXHH5m6BBeqwYHnrscoyiNjX+T9Zj3rop0C+xsmuVZo/bPYA4QFnIgigT13JnqS6yifrUSnLahI8587kgBcxTxheU3KKcdOB0Fhwkx1ydGo8VBQdqJH3kWGitU1Kzjhadzwjdk5VCONOmkEPU3pnzp7gQS1npyw5+/Y3k78MWgdaoL9EcUFO74bvZQO2/Rm+XJd7fam5Ti8bUyXsXsryj5vLAkViMRZXnAcKbaEdD0OYNNQsNR+nfrrdEalaWkcJV4KfeUwDoXZLfPiGjkffFCuvteQx2OzdlvrG8DHMWL084f/qeYz60X2ZJWPzAHTIgxNSEc4IQDrNtibf8NNQdO6t7o/wKQrgTaMBi0+urHo/8JH71eT91bHQ8i6XrtM0CV+yGV8419lM7pFyD1g+byMU95v4XDRbUqJ34ltkOMLvVl+x9rVxr4YG2ypW5fMguDNRcqeRCisP6IbE="

config :phxdemo, PhxdemoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PhxdemoWeb.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
