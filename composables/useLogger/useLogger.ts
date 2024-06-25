export function useLogger() {
  const config = useRuntimeConfig()
  const isProd = config.public.nodeEnv === 'production'
  const logAndTrack = (...args: any[]) => {
    if (isProd) {
      // @TODO: Send to sentry
      return
    }

    console.log(...args)
  }
  return { logAndTrack }
}
