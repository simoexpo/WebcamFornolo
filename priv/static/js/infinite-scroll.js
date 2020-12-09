/* ============================================
 * bootstrap-infiniteScroll.js
 * ============================================ */

!function ($) {
    'use strict';
    var InfiniteScroll = function (el, options) {
        this.$element = $(el);
        this.$data = $(el).data();
        this.$options = options;

        this.executing = false;
        this.endOfResults = false;
        this.currentPage = 0;

        var that = this;

        $(window).scroll(function () {
            if ($(window).scrollTop() >= that.$options.calculateBottom()) {
                that.loadMore();
            }
        });
    };

    InfiniteScroll.prototype = {
        constructor: InfiniteScroll,

        loadMore: function () {
            console.log("load more!");
            var $this = this;
            if ($this.executing || $this.endOfResults) return;

            $this.$element.find('.spinner-border').removeClass('d-none');

            $this.executing = true;
            $this.currentPage += 1;

            var url = $this.$options.getUrl($this.currentPage);

            $.ajax({
                contentType: 'application/json; charset=UTF-8',
                url: url,
                type: 'GET',
                success: function (retVal) {
                    $this.$options.processResults(retVal);

                    if ($this.$options.responseIsEmpty(retVal)) {
                        $this.endOfResults = true;
                        $this.$element.find('#end-of-results').removeClass('d-none');
                    }

                    $this.$element.find('.spinner-border').addClass('d-none');
                    $this.executing = false;
                }
            });
        }
    };

    $.fn.infiniteScroll = function (option) {
        return this.each(function () {
            var $this = $(this),
                data = $this.data('infinite-search'),
                options = $.extend({}, $.fn.infiniteScroll.defaults, typeof option == 'object' && option);
            if (!data) $this.data('infinite-search', (data = new InfiniteScroll(this, options)));
            if (typeof options == 'string') data[options]();
        });
    };

    $.fn.infiniteScroll.defaults = {
        calculateBottom: function () { },
        processResults: function () { },
        getUrl: function () { }
    };

    $.fn.infiniteScroll.Constructor = InfiniteScroll;
}(window.jQuery);