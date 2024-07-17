<script setup lang="ts">
import PublicHeadline from '@/modules/users/components/PublicHeadline/PublicHeadline.vue';
import PublicHeadlineEmpty from '@/modules/users/components/PublicHeadline/Empty.vue';
import WidgetGroup from '@/modules/reports/components/Widget/Group/Group.vue';
import WidgetGroupLoader from '@/modules/reports/components/Widget/Group/Loader.vue';
import WidgetCondensed from '@/modules/reports/components/Widget/Condensed/Condensed.vue';
import GistCardGroup from '@/modules/gists/components/Card/Group/Group.vue';
import GistCardGroupLoader from '@/modules/gists/components/Card/Group/Loader.vue';
import GistCardItem from '@/modules/gists/components/Card/Item/Item.vue';

const route = useRoute();
const router = useRouter();
const services = useServices()
const { data: user } = await useAsyncData('user-public-profile', () => {
    const username = route.params.username as string;
    return services.users.readOneByUsername(username);
})

const handleNavigateToDetail = (id: string) => {
    const { username } = route.params;

    router.push(`/${username}/gists/${id}`);
}
</script>

<template>
    <PublicHeadline v-if="user"
        :avatar-url="user.avatarUrl"
        :name="user.name"
        :bio="user.bio"
        :city="user.address?.city"
        :state="user.address?.state"
        class="my-10"
    />
    <PublicHeadlineEmpty v-else />

    <WidgetGroup>
        <WidgetGroupLoader :loading="false" :amount="3">
            <WidgetCondensed :value="10" label="Gists no total" />
            <WidgetCondensed :value="5" label="Gists gratuitos" />
            <WidgetCondensed :value="5" label="Gists pagos" />
        </WidgetGroupLoader>
    </WidgetGroup>

    <WidgetDefault title="Todos os gists">
        <GistCardGroup>
            <GistCardGroupLoader :loading="false">
                <GistCardItem @tap="handleNavigateToDetail" id="123" title="useCurrentUser.ts"
                    description="Hook para controlar a **store** do usuário" :price="10" lang="typescript" />
            </GistCardGroupLoader>
        </GistCardGroup>
    </WidgetDefault>
</template>