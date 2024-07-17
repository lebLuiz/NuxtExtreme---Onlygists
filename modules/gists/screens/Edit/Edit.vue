<script setup lang="ts">
import HeadlineEdit from '@/modules/gists/components/HeadlineEdit/HeadlineEdit.vue';
import CodeEdit from '@/modules/gists/components/CodeEdit/CodeEdit.vue';
import { useGist } from '@/modules/gists/composables/useGist/useGist';
import { useGistUpdate } from '@/modules/gists/composables/useGistUpdate/useGistUpdate';
import { useGistDelete } from '@/modules/gists/composables/useGistDelete/useGistDelete';
import { myselfKey } from '@/modules/users/composables/useMyself/useMyself';
import type { MyselfContextProvider } from '@/modules/users/composables/useMyself/types';

const router = useRouter();
const route = useRoute();
const confirm = useConfirm();
const { user } = inject(myselfKey) as MyselfContextProvider;

const {
    gist,
} = useGist({
    id: route.params.id as string
})
const {
    loading,
    headline,
    code,
    safeParse,
    update,
    errors,
} = useGistUpdate({ gist });
const {
    loading: loadingRemove,
    remove
} = useGistDelete({ gist })

const handleLanguageChange = (lang: string) => {
    code.value.lang = lang;
}

const handleUpdateGist = async () => {
    const isValid = safeParse().success;

    if (!isValid) return

    const response = await update();
    if (response?.id)
        router.push(`/${user.value?.username}/gist/${response?.id}`)
}

const handleDeleteGist = () => {
    confirm.require({
        header: 'Apagar Gist?',
        message: 'Tem certeza que deseja apagar esse gist?',
        rejectLabel: 'Voltar',
        acceptLabel: 'Quero apagar!',
        accept: async () => {
            await remove();
            router.push(`/${user.value?.username}`)
        }
    })
}
</script>

<template>
    <ConfirmDialog />

    <WidgetDefault title="Qual gist você quer criar?" class="my-5">
        <HeadlineEdit v-model="headline" :errors="errors" @language-change="handleLanguageChange" />
    </WidgetDefault>

    <WidgetDefault title="Show me the code">
        <ClientOnly>
            <CodeEdit v-model="code" :errors="errors" />
        </ClientOnly>
    </WidgetDefault>

    <div class="flex gap-2">
        <Button
            @click="handleUpdateGist"
            :loading="loading"
            class="mt-5 w-full md:w-auto"
            label="Atualizar"
            icon="pi pi-plus"
            icon-pos="right"
        />

        <Button
            @click="handleDeleteGist"
            :loading="loadingRemove"
            class="mt-5 w-full md:w-auto"
            label="Deletar"
            icon-pos="right"
            severity="danger"
        />
    </div>
</template>