HTMLWidgets.widget({

  name: 'ddbar',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var chartDom = document.getElementById(el.id);
    var myChart = echarts.init(chartDom);
    var option;

    return {

      renderValue: function(x) {

        // TODO: code to render the widget, e.g.
        const allDataGroups = x.data

// Generate 1+1 options for each data
    const allOptionsWithItemGroupId = {};
    const allOptionsWithoutItemGroupId = {};

    allDataGroups.forEach((dataGroup, index) => {
      const { dataGroupId, data } = dataGroup;
      const optionWithItemGroupId = {
        xAxis: {
          type: 'category'
        },
        yAxis: {},
        // dataGroupId: dataGroupId,
        animationDurationUpdate: 500,
        series: {
          type: 'bar',
          // id: "sales",
          dataGroupId: dataGroupId,
          encode: {
            x: 0,
            y: 1,
            itemGroupId: 2
          },
          data: data,
          universalTransition: {
            enabled: true,
            divideShape: 'clone'
          }
        },
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
        ]
      };
      const optionWithoutItemGroupId = {
        xAxis: {
          type: 'category'
        },
        yAxis: {},
        // dataGroupId: dataGroupId,
        animationDurationUpdate: 500,
        series: {
          type: 'bar',
          // id: "sales",
          dataGroupId: dataGroupId,
          encode: {
            x: 0,
            y: 1
            // itemGroupId: 2,
          },
          data: data.map((item, index) => {
            return item.slice(0, 2); // This is what "without itemGroupId" means
          }),
          universalTransition: {
            enabled: true,
            divideShape: 'clone'
          }
        },
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
        ]
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

    option = allOptionsWithItemGroupId['1']; // The initial option is the root data option

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

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
