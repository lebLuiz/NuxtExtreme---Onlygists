<script setup lang="ts">
import HeadlineEdit from '@/modules/users/components/HeadlineEdit/HeadlineEdit.vue';
import HeadlineEditLoader from '@/modules/users/components/HeadlineEdit/Loader.vue';
import BasicInfoForm from '@/modules/users/components/BasicInfoForm/BasicInfoForm.vue'
import AddressForm from '@/modules/users/components/AddressForm/AddressForm.vue'

import { myselfKey } from '@/modules/users/composables/useMyself/useMyself';
import type { MyselfContextProvider } from '@/modules/users/composables/useMyself/types';

const { user, loading } = inject(myselfKey) as MyselfContextProvider;

const handleShare = (username: string) => {
    console.log(username);
};

const handleNavigateToProfile = (username: string) => {
    console.log(username);
};
</script>

<template>
    <HeadlineEditLoader :loading="loading">
        <HeadlineEdit
            class="my-10"
            :username="user?.username ?? ''"
            :avatar-url="user?.avatarUrl ?? ''"
            @share="handleShare"
            @navigate-to-profile="handleNavigateToProfile"
        />
    </HeadlineEditLoader>

    <WidgetDefault title="Informações básicas">
        <BasicInfoForm />
    </WidgetDefault>

    <WidgetDefault title="Endereço" class="mt-5">
        <AddressForm />
    </WidgetDefault>
</template>
