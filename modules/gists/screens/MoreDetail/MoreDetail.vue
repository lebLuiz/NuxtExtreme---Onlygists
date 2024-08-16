<script setup lang="ts">
import PublicHeadline from '@/modules/gists/components/PublicHeadline/PublicHeadline.vue';
import PublicHeadlineLoader from '@/modules/gists/components/PublicHeadline/Loader.vue';
import PublicHeadlineEmpty from '@/modules/gists/components/PublicHeadline/Empty.vue';
import GistCodeSnippet from '@/modules/gists/components/CodeSnippet/CodeSnippet.vue';
import LazyDialogPaymentSuccess from '@/modules/payments/components/DialogPaymentSuccess/DialogPaymentSuccess.vue';
import LazyDialogPaymentError from '@/modules/payments/components/DialogPaymentError/DialogPaymentError.vue';
import { useSession } from '@/modules/auth/composables/useSession/useSession'
import { myselfKey } from '@/modules/users/composables/useMyself/useMyself';
import { useGistContent } from '@/modules/gists/composables/useGistContent/useGistContent';
import { useStripeCheckout } from '@/modules/payments/composables/useStripeCheckout/useStripeCheckout';
import type { MyselfContextProvider } from '@/modules/users/composables/useMyself/types';

const { user } = inject(myselfKey) as MyselfContextProvider;
const session = useSession();

const route = useRoute();
const router = useRouter();
const services = useServices();
const isPaymentSuccessfully = ref<boolean>(false);
const isPaymentFail = ref<boolean>(false);

const handleNavigateToGistEdit = () => {
    router.push(`/app/gist/${route.params?.id}/edit`);
}
const { data: gist, pending: loading } = await useAsyncData('gist-detail', () => {
    const gistId = route.params.id as string;
    return services.gists.readOne(gistId);
})

const { gistContent, loading: loadingContent } = useGistContent({
    gist
})
const { checkoutUrl, createCheckoutUrl } = useStripeCheckout()

const handlePay = async () => {
    await createCheckoutUrl({
        username: route.params.username as string,
        gistId: route.params.id as string,
        price: String(gist.value?.price!),
    })

    if (!checkoutUrl.value)
        return;

    window.location.href = checkoutUrl.value;
}

onMounted(() => {
    const { success_payment, fail_payment } = route.query;

    if (success_payment) {
        isPaymentSuccessfully.value = true;
    }
    if (fail_payment) {
        isPaymentFail.value = true;
    }
})

defineOgImage({
    component: 'GistDetail',
    props: {
        title: `${gist.value?.title} by @${gist.value?.profiles?.username}`,
        description: `Veja o gist de ${gist.value?.profiles?.name} no onlygists`,
    }
})

useSeoMeta({
    title: `${gist.value?.title} by @${gist.value?.profiles?.username}`,
    description: `Veja o gist de ${gist.value?.profiles?.name} no onlygists`,
    ogTitle: `${gist.value?.title} by @${gist.value?.profiles?.username}`,
    ogDescription: `Veja o gist de ${gist.value?.profiles?.name} no onlygists`,
})
</script>

<template>
    <PublicHeadlineLoader :loading="loading">
        <PublicHeadline v-if="gist"
            :title="gist.title"
            :description="gist.description"
            :author="gist.profiles.username"
            :lang="gist.lang" />
        <PublicHeadlineEmpty v-else />
    </PublicHeadlineLoader>

    <GistCodeSnippet v-if="gist"
        :loading="loadingContent"
        :lang="gist.lang"
        :code="gistContent"
        :is-paid="gist.isPaid" />

    <div v-if="gist"
        class="flex flex-col md:flex-row gap-2">
        <Button v-if="gist && user?.username !== route.params?.username"
            :label="`Comprar por ${gist.price}`"
            class="mt-5 w-full md:w-auto"
            icon-pos="right"
            icon="pi pi-shopping-bag"
            @click="handlePay" />

        <Button v-if="session.isLogged() && user?.username === route.params?.username"
            label="Editar este gist"
            class="mt-5 w-full md:w-auto"
            icon-pos="right"
            icon="pi pi-pencil"
            @click="handleNavigateToGistEdit" />
    </div>

    <LazyDialogPaymentSuccess v-model:visible="isPaymentSuccessfully" />
    <LazyDialogPaymentError v-model:visible="isPaymentFail" />
</template>