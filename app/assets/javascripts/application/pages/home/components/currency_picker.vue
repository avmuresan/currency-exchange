<template lang="pug">
  .card.mb-4.shadow-sm
    .card-header
      b-dropdown( class="mt-3" :disabled="disabled" :text="currency" :right="true" :block="true" role="presentation")
        b-dropdown-item( v-for="option in currencies"
                         :key="option"
                         @click="changeCurrency(option)"
                         link-class="text-right"
                         :active="option === currency") {{ option }}
    .card-body
      b-form-input( v-model="amount" type="number" placeholder="Enter a value" :disabled="disabled" @blur="onChange" )
</template>

<script>

  export default {
    props: {
      disabled: Boolean,
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
    computed: {
      currencies() {
        return this.$store.getters['currencies/all'];
      }
    },
    methods: {
      changeCurrency(currency) {
        this.currency = currency;
        this.onChange();
      },
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
