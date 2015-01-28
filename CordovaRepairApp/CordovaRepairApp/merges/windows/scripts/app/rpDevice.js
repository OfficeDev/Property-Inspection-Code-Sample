
var rpDevice = {
    beforeBtnClicked:function () {
        $("#incidentpage>table td.rp_right").fadeOut(700,
            function () {
                $("#incidentpage>table td.rp_middle").fadeIn(700)
            });

        $("#rp_inspectionDetail").fadeOut(700,
            function () {
                $("#rp_propertyDetailTable>.rp_bottom").fadeIn(700);
            });

        $(".rp_backBtn").fadeOut(300, function () {
            $(".rp_header>.rp_middle").fadeIn(400);
            $(".rp_header>.rp_right").fadeOut(400);
        });
    },
    showBeforeBtn: function () {
        $("#incidentpage>table td.rp_middle").fadeOut(700,
                    function () {
                        $("#incidentpage>table td.rp_right").fadeIn(700);
                    });


        $("#rp_propertyDetailTable>.rp_bottom").fadeOut(700,
            function () {
                $("#rp_inspectionDetail").fadeIn(700);
            });


        $(".rp_backBtn").fadeIn(300, function () {
            $(".rp_header>.rp_right").fadeIn(400);
            $(".rp_header>.rp_middle").fadeOut(400);

        });
    }
};


