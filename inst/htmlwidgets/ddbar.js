HTMLWidgets.widget({

  name: 'ddbar',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var chartDom = document.getElementById(el.id);
    var myChart = echarts.init(chartDom);
    var option;

    //var xAxis = {type: 'category'};
    //var yAxis = {};
    //var encode = {
    //    x: 0,
    //    y: 1,
    //    itemGroupId: 2
    //};

    //const flip = new Boolean(false);

    //if(flip == true){
    //  xAxis = {};
    //  yAxis = {type: 'category'};
    //  encode = {
    //    x: 1,
    //    y: 0,
    //    itemGroupId: 2
    //  };
    //}

    return {

      renderValue: function(x) {

        const allDataGroups = x.data
        const extraOptions = x.options

        var xAxis = {type: 'category'};
        var yAxis = {};
        var encode = {
          x: 0,
          y: 1,
          itemGroupId: 2
        };

        if(x.flip === "TRUE"){
          xAxis = {};
          yAxis = {type: 'category'};
          encode = {
            x: 1,
            y: 0,
            itemGroupId: 2
          };
        }

        const baseOptions = {
          xAxis: xAxis,
          yAxis: yAxis,
          graphic: [
            {
              type: 'text',
              left: 50,
              top: 20,
              style: {
                text: 'Back',
                fontSize: 18
              },
              onclick: function () {
                goBack();
              }
            }
          ],
          animationDurationUpdate: 1000
        }

// Generate 1+1 options for each data
    const allOptionsWithItemGroupId = {};
    const allOptionsWithoutItemGroupId = {};

    allDataGroups.forEach((dataGroup, index) => {
      const { dataGroupId, data } = dataGroup;
      const optionWithItemGroupId = {
        ...baseOptions,
        ...extraOptions,
        series: {
          type: 'bar',
          // id: "sales",
          dataGroupId: dataGroupId,
          encode: encode,
          data: data,
          universalTransition: {
            enabled: true,
            divideShape: 'clone'
          }
        },
        title: {
          text: dataGroupId,
          left: "center",
          top: "bottom",
          textStyle: {
            fontSize: 20
          }
        }
      };

      const optionWithoutItemGroupId = {
        ...baseOptions,
        ...extraOptions,
        series: {
          type: 'bar',
          // id: "sales",
          dataGroupId: dataGroupId,
          encode: encode,
          data: data,
          universalTransition: {
            enabled: true,
            divideShape: 'clone'
          }
        },
        title: {
          text: dataGroupId,
          left: "center",
          top: "bottom",
          textStyle: {
            fontSize: 20
          }
        }
      };
      allOptionsWithItemGroupId[dataGroupId] = optionWithItemGroupId;
      allOptionsWithoutItemGroupId[dataGroupId] = optionWithoutItemGroupId;
    });

// A stack to remember previous dataGroupsId
    const dataGroupIdStack = [];

    const goForward = (dataGroupId) => {
      dataGroupIdStack.push(myChart.getOption().series[0].dataGroupId); // push current dataGroupId into stack.
      myChart.setOption(allOptionsWithoutItemGroupId[dataGroupId], false);
      myChart.setOption(allOptionsWithItemGroupId[dataGroupId], false); // setOption twice? Yeah, it is dirty.
    };

    const goBack = () => {
      if (dataGroupIdStack.length === 0) {
        console.log('Already in root dataGroup!');
      } else {
        console.log('Go back to previous level');
        myChart.setOption(
          allOptionsWithoutItemGroupId[myChart.getOption().series[0].dataGroupId],
          false
        );
        myChart.setOption(allOptionsWithItemGroupId[dataGroupIdStack.pop()], true); // Note: the parameter notMerge is set true
      }
    };

    option = allOptionsWithItemGroupId['']; // The initial option is the root data option

    myChart.on('click', 'series.bar', (params) => {
      if (params.data[2]) {
        // If current params is not belong to the "childest" data, then it has data[2]
        const dataGroupId = params.data[2];
        goForward(dataGroupId);
      }
    });

        option && myChart.setOption(option);

        myChart
      },

      resize: function(width, height) {

        if(!myChart)
          return;

        myChart.resize({
          width: width,
          height: height
        });

      }

    };
  }
});
