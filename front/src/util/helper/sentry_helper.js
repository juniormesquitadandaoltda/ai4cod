import * as Sentry from '@sentry/browser'

if (process.env.NEXT_PUBLIC_SENTRY_DNS)
  Sentry.init({
    dsn: process.env.NEXT_PUBLIC_SENTRY_DNS,
    // Adds request headers and IP for users, for more info visit:
    // https://docs.sentry.io/platforms/javascript/configuration/options/#sendDefaultPii
    sendDefaultPii: true,
    // Alternatively, use `process.env.npm_package_version` for a dynamic release version
    // if your build tool supports it.
    release: process.env.NEXT_PUBLIC_GITHUB_RELEASE,
    integrations: [
      Sentry.browserTracingIntegration(),
      Sentry.replayIntegration(),
      // Sentry.feedbackIntegration({
      //   // Additional SDK configuration goes in here, for example:
      //   colorScheme: 'system',
      // }),
    ],
    // Enable logs to be sent to Sentry
    _experiments: { enableLogs: true },
    // Set tracesSampleRate to 1.0 to capture 100%
    // of transactions for tracing.
    // We recommend adjusting this value in production
    // Learn more at
    // https://docs.sentry.io/platforms/javascript/configuration/options/#traces-sample-rate
    tracesSampleRate: parseFloat(process.env.NEXT_PUBLIC_SENTRY_RATE),
    // Set `tracePropagationTargets` to control for which URLs trace propagation should be enabled
    // tracePropagationTargets: ["localhost", /^https:\/\/yourserver\.io\/api/],
    // Capture Replay for 10% of all sessions,
    // plus for 100% of sessions with an error
    // Learn more at
    // https://docs.sentry.io/platforms/javascript/session-replay/configuration/#general-integration-configuration
    replaysSessionSampleRate: parseFloat(process.env.NEXT_PUBLIC_SENTRY_RATE),
    replaysOnErrorSampleRate: parseFloat(process.env.NEXT_PUBLIC_SENTRY_RATE),
  })

export default Sentry
