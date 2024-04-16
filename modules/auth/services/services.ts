import type { SupabaseClient } from '@supabase/supabase-js'

interface ServiceOptions {
  redirectToUrl: string
}

export default (client: SupabaseClient, options: ServiceOptions) => ({
  async signInWithGithub() {
    const response = await client.auth.signInWithOAuth({
      provider: 'github',
      options: {
        redirectTo: options.redirectToUrl,
      },
    })
    return response
  },
})
