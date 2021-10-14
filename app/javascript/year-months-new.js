var moment = require("moment");


$(document).on ("turbolinks:load", function () {
  var day_num = $('.js-year_month_day').length;
  var first_date = document.getElementById("first_date");
  var last_date = document.getElementById("last_date");
  
  $('#add_item_button').on('click', function() {
    $('.js-year_month_day').remove();
    function loopYmd(startDate, endDate) {
      let start = moment(startDate);
      const end = moment(endDate);
      const day_jp = ["日","月","火","水","木","金","土"];
      while(start.unix() <= end.unix()) {
        if (start.day() == 0) {
          $('#year_month_days_box').append(
            '<div class="js-year_month_day" id="add_day_' + day_num + '">'
            + '<select class="form-control" name="year_month[days_attributes][' + day_num + '][date]" id="year_month_days_attributes_' + day_num + '_date">'
            +  '<option value="' + start.format('YYYY-MM-DD') + '">' + start.format('YYYY-MM-DD') + '</option>'
            + '</select>'
            + '<span>(' + day_jp[start.day()] + ')</span>'
            + '<select class="form-control" name="year_month[days_attributes][' + day_num + '][day_type]" id="year_month_days_attributes_' + day_num + '_day_type">'
            +  '<option value="平日">平日</option>'
            +  '<option value="法定休日" >法定休日</option>'
            +  '<option value="法定外休日" selected>法定外休日</option>'
            + '</select>'
            +'</div>'
          )
        } else if (start.day() == 6) {
          $('#year_month_days_box').append(
            '<div class="js-year_month_day" id="add_day_' + day_num + '">'
            + '<select class="form-control" name="year_month[days_attributes][' + day_num + '][date]" id="year_month_days_attributes_' + day_num + '_date">'
            +  '<option value="' + start.format('YYYY-MM-DD') + '">' + start.format('YYYY-MM-DD') + '</option>'
            + '</select>'
            + '<span>(' + day_jp[start.day()] + ')</span>'
            + '<select class="form-control" name="year_month[days_attributes][' + day_num + '][day_type]" id="year_month_days_attributes_' + day_num + '_day_type">'
            +  '<option value="平日">平日</option>'
            +  '<option value="法定休日" selected>法定休日</option>'
            +  '<option value="法定外休日">法定外休日</option>'
            + '</select>'
            +'</div>'
          )
        } else {
          $('#year_month_days_box').append(
            '<div class="js-year_month_day" id="add_day_' + day_num + '">'
            + '<select class="form-control" name="year_month[days_attributes][' + day_num + '][date]" id="year_month_days_attributes_' + day_num + '_date">'
            +  '<option value="' + start.format('YYYY-MM-DD') + '">' + start.format('YYYY-MM-DD') + '</option>'
            + '</select>'
            + '<span>(' + day_jp[start.day()] + ')</span>'
            + '<select class="form-control" name="year_month[days_attributes][' + day_num + '][day_type]" id="year_month_days_attributes_' + day_num + '_day_type">'
            +  '<option value="平日" selected>平日</option>'
            +  '<option value="法定休日">法定休日</option>'
            +  '<option value="法定外休日">法定外休日</option>'
            + '</select>'
            +'</div>'
          )
        }
        day_num ++;
        start.add(1, 'days');
      }
    }
    loopYmd(first_date.value, last_date.value);
  });
});