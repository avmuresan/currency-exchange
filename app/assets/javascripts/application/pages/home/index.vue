<template lang="pug">
  .container
    .pricing-header.px-3.py-3.pt-md-5.pb-md-4.mx-auto.text-center
      h4 Exchange date
      b-form-datepicker.col-md-4.offset-md-4( v-model="date" :min="minDate" :max="maxDate" @input="dateChanged" :disabled="isLoading" )
    .card-deck.mb-3.text-center
      .col-md-4
      CurrencyPicker( :providedAmount="formData.fromAmount"
                      :providedCurrency="formData.from"
                      :disabled="isLoading"
                      :from="true"
                      @change="convert" )

      CurrencyPicker( :providedAmount="formData.toAmount"
                      :providedCurrency="formData.to"
                      :disabled="isLoading"
                      :from="false"
                      @change="convert")
      .col-md-4
</template>

<script>

  import Api from '$shared/api';
  import CurrencyPicker from './components/currency_picker';
  import moment from 'moment';
  import _ from 'underscore';

  export default {
    components: {
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
