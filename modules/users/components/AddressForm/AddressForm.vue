<script setup lang="ts">
    import type { Address } from '@/modules/users/entities/Address/Address';

    const props = defineProps<{
        loading?: boolean;
    }>()
    const emit = defineEmits<{
        (e: 'trigger-address-search'): void
    }>();
    const address = defineModel<Address>({
        required: true,
        default: {
            zipCode: '',
            number: '',
            street: '',
            city: '',
            state: '',
            neighborhood: '',
            complement: '',
        }
    })
</script>

<template>
    <div class="flex flex-col gap-4">

        <div class="flex flex-col lg:flex-row gap-2">
            <div class="flex flex-col lg:flex-row gap-2 flex-1">
                <div class="flex flex-col gap-2 flex-1">
                    <label for="cep">
                        CEP
                        <i v-if="props?.loading" class="pi pi-spinner text-gray-500 animate-spin" />
                    </label>
                    <InputText
                        id="cep"
                        placeholder="00000-000"
                        v-maska
                        data-maska="#####-###"
                        v-model="address.zipCode"
                        @blur="() => emit('trigger-address-search')" />
                </div>

                <div class="flex flex-col gap-2 flex-1">
                    <label for="number">
                        Número
                    </label>
                    <InputText
                        id="number"
                        placeholder="42"
                        v-model="address.number" />
                </div>
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-2">
            <div class="flex flex-col gap-2 flex-1">
                <label for="city">Cidade</label>
                <InputText
                    id="city"
                    placeholder="São Paulo"
                    v-model="address.city" />
            </div>

            <div class="flex flex-col gap-2 flex-1">
                <label for="state">Estado</label>
                <InputText
                    id="state"
                    placeholder="São Paulo"
                    v-model="address.state" />
            </div>
        </div>

        <div class="flex flex-col md:flex-row gap-2">
            <div class="flex flex-col gap-2 flex-1">
                <label for="neighborhood">Bairro</label>
                <InputText
                    id="neighborhood"
                    placeholder="Aclimação"
                    v-model="address.neighborhood" />
            </div>

            <div class="flex flex-col gap-2 flex-1">
                <label for="complement">Complemento</label>
                <InputText
                    id="complement"
                    placeholder="Apto 22"
                    v-model="address.complement" />
            </div>
        </div>
    </div>
</template>