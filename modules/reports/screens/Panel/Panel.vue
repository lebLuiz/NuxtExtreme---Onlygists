<script setup lang="ts">
import { useScroll } from '@vueuse/core'
import WidgetGroup from '@/modules/reports/components/Widget/Group/Group.vue';
import WidgetGroupLoader from '@/modules/reports/components/Widget/Group/Loader.vue';
import WidgetCondensed from '@/modules/reports/components/Widget/Condensed/Condensed.vue';
import GistCardGroup from '@/modules/gists/components/Card/Group/Group.vue';
import GistCardGroupLoader from '@/modules/gists/components/Card/Group/Loader.vue';
import GistCardItem from '@/modules/gists/components/Card/Item/Item.vue';
import PaymentSetupAlert from '~/modules/payments/components/PaymentSetupAlert/PaymentSetupAlert.vue';

import { myselfKey } from '@/modules/users/composables/useMyself/useMyself';
import type { MyselfContextProvider } from '@/modules/users/composables/useMyself/types';

import { useGistsReport } from '@/modules/reports/composables/useGistsReport/useGistsReport';
import { useGistList } from '@/modules/gists/composables/useGistList/useGistList';
import { useStripeAccountCreate } from '@/modules/payments/composables/useStripeAccountCreate/useStripeAccountCreate';
import { useStripeAccountValidate } from '@/modules/payments/composables/useStripeAccountValidate/useStripeAccountValidate';

const route = useRoute();
const router = useRouter();
const { user } = inject(myselfKey) as MyselfContextProvider;

const { loading: paymentCreateLoading, create } = useStripeAccountCreate();
const { isValid, validate } = useStripeAccountValidate();

const {
    loading: reportLoading,
    totalGists,
    totalFreeGists,
    totalPaidGists,
    totalSoldGists,
} = useGistsReport({
    user,
    isMyself: true
});

const {
    gists,
    loading: loadingList,
    fetchMoreGistsByUsername
} = useGistList({
    username: user.value?.username!
});

const handleNavigateToDetail = (id: string) => {
    const { username } = route.params;
    router.push(`/${username}/gist/${id}`);
}

const handlePaymentSetup = async () => {
    const response = await create(user.value?.email!)

    if (!response)
        return

    window.location.href = response.onboardingUrl;
}

const { arrivedState } = useScroll(window, {
    offset: { bottom: 100 }
})

watch(
    () => arrivedState.bottom,
    () => {
        if (!arrivedState.bottom)
            return;

        fetchMoreGistsByUsername();
    }
)

onMounted(() => {
    validate(user.value?.paymentConnectedAccount)
})
</script>

<template>
    <PaymentSetupAlert v-if="!isValid"
        @setup="handlePaymentSetup"
        :loading="paymentCreateLoading" />

    <WidgetGroup>
        <WidgetGroupLoader :loading="reportLoading" :amount="3">
            <WidgetCondensed :value="totalGists" label="Gists no total" />
            <WidgetCondensed :value="totalFreeGists" label="Gists gratuitos" />
            <WidgetCondensed :value="totalPaidGists" label="Gists pagos" />
            <WidgetCondensed :value="totalSoldGists" label="Gists vendidos" />
        </WidgetGroupLoader>
    </WidgetGroup>

    <WidgetDefault v-if="!!gists?.length" title="Todos os gists">
        <GistCardGroup>
            <GistCardGroupLoader :loading="loadingList">
                <GistCardItem v-for="gist in gists" :key="gist.id"
                    @tap="handleNavigateToDetail"
                    :id="gist.id"
                    :title="gist.title"
                    :description="gist.description"
                    :price="gist.price"
                    :lang="gist.lang" />
            </GistCardGroupLoader>
        </GistCardGroup>
    </WidgetDefault>
</template>