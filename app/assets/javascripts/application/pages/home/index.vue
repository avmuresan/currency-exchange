<template lang="pug">
  .container
    .pricing-header.px-3.py-3.pt-md-5.pb-md-4.mx-auto.text-center
      h4 Exchange date
      Datetime( v-model="date" :min-datetime="minDate" :max-datetime="maxDate" @input="dateChanged" :disabled="isLoading" )
    .card-deck.mb-3.text-center
      CurrencyPicker( :providedAmount="formData.fromAmount"
                      :providedCurrency="formData.from"
                      :currencies="currencies"
                      :disabled="isLoading"
                      :from="true"
                      @change="convert" )

      CurrencyPicker( :providedAmount="formData.toAmount"
                      :providedCurrency="formData.to"
                      :currencies="currencies"
                      :disabled="isLoading"
                      :from="false"
                      @change="convert")
</template>

<script>

  import Api from '$shared/api';
  import CurrencyPicker from './components/currency_picker';
  import { Datetime } from 'vue-datetime';
  import moment from 'moment';
  import _ from 'underscore';

  export default {
    components: {
      Datetime,
      CurrencyPicker
    },
    data() {
      return {
        isLoading: false,
        minDate: moment().subtract(3,'months').toISOString(),
        maxDate: moment().toISOString(),
        date: moment().toISOString(),
        formData: {
          date: moment().format('YYYY-MM-DD'),
          fromAmount: 0,
          toAmount: 0,
          from: 'USD',
          to: 'EUR'
        }
      };
    },
    computed: {
      currencies() {
        return _.map(this.$store.getters['currencies/all'], (currency) => {
          return { value: currency, text: currency };
        });
      }
    },
    methods: {
      dateChanged(newDate) {
        this.formData.date = moment(newDate).format('YYYY-MM-DD');
        const payload = {
          from: true,
          currency: this.formData.from,
          amount: this.formData.fromAmount
        };
        this.convert(payload);
      },
      convert({ from, amount, currency }) {
        if ((this.isLoading) || (amount === 0)) {
          return;
        }

        const otherCurrency = from ? this.formData.to : this.formData.from;
        if (currency === otherCurrency) {
          this.setValues(from, amount, amount, currency);
          return;
        }

        this.isLoading = true;
        Api.get(`/convert/${amount}/${currency}/to/${otherCurrency}?date=${this.formData.date}`)
          .then((response) => {
            this.setValues(from, amount, response.body.result, currency);
            this.isLoading = false;
          })
          .catch((response) => {
            if (response.body.errors) {
              alert(response.body.errors[0]);
            }
            else {
              alert('Something went wrong');
            }
            this.isLoading = false;
          });
      },
      setValues(from, firstAmount, secondAmount, currency) {
        if (from) {
          this.formData.from = currency;
          this.formData.fromAmount = firstAmount;
          this.formData.toAmount = secondAmount;
        }
        else {
          this.formData.to = currency;
          this.formData.toAmount = firstAmount;
          this.formData.fromAmount = secondAmount;
        }
      }
    }
  };
</script>
