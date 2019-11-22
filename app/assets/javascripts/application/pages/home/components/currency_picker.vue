<template lang="pug">
  .card.mb-4.shadow-sm
    .card-header
      b-form-select( v-model="currency" :options="currencies" size="sm" class="mt-3" :disabled="disabled" @change="onChange" )
    .card-body
      b-form-input( v-model="amount" type="number" placeholder="Enter a value" :disabled="disabled" @blur="onChange" )
</template>

<script>

  export default {
    props: {
      disabled: Boolean,
      currencies: Array,
      providedCurrency: String,
      providedAmount: Number,
      from: Boolean
    },
    data() {
      return {
        currency: this.providedCurrency,
        amount: this.providedAmount
      };
    },
    methods: {
      onChange() {
        const payload = {
          from: this.from,
          currency: this.currency,
          amount: Number(this.amount)
        };
        this.$emit('change', payload);
      }
    },
    watch: {
      providedCurrency(newCurrency) {
        this.currency = newCurrency;
      },
      providedAmount(newAmount) {
        this.amount = newAmount;
      }
    }

  };
</script>
