import { serverSupabaseUser } from '#supabase/server'

export interface AuthContext {
    isAuthenticated: boolean
    user: { id: string } | null
}

export default defineEventHandler(async (event) => {
    const url = getRequestURL(event)

    const isWebhook = url.pathname.startsWith('/webhooks')
    if (isWebhook) return

    const isApiCall = url.pathname.startsWith('/api')
    if (!isApiCall) return

    const user = await serverSupabaseUser(event)
    const contextAuth: AuthContext = {
        user,
        isAuthenticated: !!user,
    }

    event.context.auth = contextAuth
})
