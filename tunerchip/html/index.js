$(function () {
    function display(bool, view) {
        if (bool == false) {
            $("#container").hide();
            $("#log").hide();
            $("#tuner").hide();
        } else {
            $("#container").show();

            if(view == "tune") {
                $("#tuner").show()
            } else if(view == "tunelog") {
                $("#log").show()
            } 
            else {
                display(false, "tune")
            }
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            display(item.status, item.view)
        } else if(item.type == "update") {
        	$("#rpm").text("RPM: " + item.rpm);
        	$("#speed").text("Speed: " + item.speed);
        } else if(item.type == "tunelog") {
                myChart2.data.datasets[0].data[0] = item.one;
                myChart2.data.datasets[0].data[1] = item.two;
                myChart2.data.datasets[0].data[2] = item.three;
                myChart2.data.datasets[0].data[3] = item.four;
                myChart2.data.datasets[0].data[4] = item.five;
                myChart2.data.datasets[0].data[5] = item.six;
                myChart2.data.datasets[0].data[6] = item.seven;
                myChart2.data.datasets[0].data[7] = item.eight;
                myChart2.data.datasets[0].data[8] = item.nine;
                myChart2.data.datasets[0].data[9] = item.ten;
                myChart2.data.datasets[0].data[10] = item.eleven;
                myChart2.data.datasets[0].data[11] = item.twelve;
                myChart2.data.datasets[0].data[12] = item.thirteen;

                myChart2.update();
        } else if(item.type == "tunefile") {
                myChart.data.datasets[0].data[0] = item.one;
                myChart.data.datasets[0].data[1] = item.two;
                myChart.data.datasets[0].data[2] = item.three;
                myChart.data.datasets[0].data[3] = item.four;
                myChart.data.datasets[0].data[4] = item.five;
                myChart.data.datasets[0].data[5] = item.six;
                myChart.data.datasets[0].data[6] = item.seven;
                myChart.data.datasets[0].data[7] = item.eight;
                myChart.data.datasets[0].data[8] = item.nine;
                myChart.data.datasets[0].data[9] = item.ten;
                myChart.data.datasets[0].data[10] = item.eleven;
                myChart.data.datasets[0].data[11] = item.twelve;
                myChart.data.datasets[0].data[12] = item.thirteen;

                myChart.update();
        }
    })

    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://tunerchip/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post('http://tunerchip/exit', JSON.stringify({}));
        return
    })

    $("#close2").click(function () {
        $.post('http://tunerchip/exit', JSON.stringify({}));
        return
    })
    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        //let inputValue = $("#input").val()
        let inputValue = myChart.data.datasets[0].data[0]
        if (inputValue.length >= 100) {
            $.post("http://tunerchip/error", JSON.stringify({
                error: "Input was greater than 100"
            }))
            return
        } else if (!inputValue) {
            $.post("http://tunerchip/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('http://tunerchip/main', JSON.stringify({
            text: inputValue,
        }));
        return;
    })

    // Sends tune info back to client
    $("#tune").click(function () {
        $.post("http://tunerchip/tune", JSON.stringify({
                one: myChart.data.datasets[0].data[0],
                two: myChart.data.datasets[0].data[1],
                three: myChart.data.datasets[0].data[2],
                four: myChart.data.datasets[0].data[3],
                five: myChart.data.datasets[0].data[4],
                six: myChart.data.datasets[0].data[5],
                seven: myChart.data.datasets[0].data[6],
                eight: myChart.data.datasets[0].data[7],
                nine: myChart.data.datasets[0].data[8],
                ten: myChart.data.datasets[0].data[9],
                eleven: myChart.data.datasets[0].data[10],
                twelve: myChart.data.datasets[0].data[11],
                thirteen: myChart.data.datasets[0].data[12],
        }))  
    })

    $("#logbtn").click(function() {
        $("#tuner").hide();
        $("#log").show();
        return;
    })

    $("#tunerbtn").click(function() {
        $("#log").hide();
        $("#tuner").show();
        return;
    })
})