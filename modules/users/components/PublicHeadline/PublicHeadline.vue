<script setup lang="ts">
const props = withDefaults(defineProps<{
    name: string;
    avatarUrl: string;
    bio?: string;
    city?: string;
    state?: string;
}>(), {
    name: 'Luiz Barbosa',
    avatarUrl: 'https://avatars.githubusercontent.com/u/49081359?s=400&u=1180eee3ccc641a9d8f7d632669eb63246c761b7&v=4',
    bio: 'Software Enginner',
    city: 'Dois Vizinhos',
    state: 'PR'
});
</script>

<template>
    <div class="w-full flex flex-col justify-center items-center gap-2">
        <div class="w-24 md:w-32 rounded-full overflow-hidden">
            <img class="w-full" :src="props.avatarUrl" alt="Foto do usuário">
        </div>
        <h1 class="font-[Inter] text-gray-700 text-center font-bold text-2xl md:text-3xl">{{ props.name }}</h1>
        <p class="font-[Inter] text-gray-700 text-center font-regular md:text-lg" v-if="props.bio">{{ props.bio }}</p>
        <p class="font-[Inter] font-regular text-gray-500 text-sm md:text-base" v-if="props.city && props.state">
            <i class="pi pi-map-marker" />
            {{ props.city }}, {{ props.state }}
        </p>
    </div>
</template>