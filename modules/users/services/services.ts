import type { SupabaseClient } from '@supabase/supabase-js'
import type { Database } from '@/libs/supabase/schema'
import { getMySelfAdapter } from './adapters'

export default (client: SupabaseClient<Database>) => ({
  async getMyself(id: string) {
    const response = await client.from('profiles').select('*').eq('id', id).limit(1).single()
    const user = getMySelfAdapter(response.data)
    return user
  },
})
