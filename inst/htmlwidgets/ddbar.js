HTMLWidgets.widget({

  name: 'ddbar',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var myChart = null;
    var option = null;
    var initialized = false;

    return {

      renderValue: function(x) {


        if (!initialized) {
          initialized = true;
          // Code to set up event listeners and anything else that needs to run just once

          myChart = echarts.init(document.getElementById(el.id));

        } // end of initialization procedure

        const allDataGroups = null;
        const extraOptions = null;

        allDataGroups = x.data;
        extraOptions = x.options;

          var xAxis = {type: 'category'};
          var yAxis = {};
          var encode = {
            x: 0,
            y: 1,
          };

          if(x.flip === "TRUE"){
            xAxis = {};
            yAxis = {type: 'category'};
            encode = {
              x: 1,
              y: 0,
            };
          }

        // Generate 1+1 options for each data
      const allOptionsWithItemGroupId = {};
      const allOptionsWithoutItemGroupId = {};

      allDataGroups.forEach((dataGroup, index) => {
        const { dataGroupId, data } = dataGroup;

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
            animationDurationUpdate: 500,
          }

        const title = {
            title: {
              text: dataGroupId,
              left: "center",
              top: "bottom",
              textStyle: {
                fontSize: 20
              }
            }
          };

        if(x.showTitle === "FALSE"){
          title.title.text = "";
        }

        const optionWithItemGroupId = {
          ...baseOptions,
          ...title,
          series: {
            type: 'bar',
            // id: "sales",
            dataGroupId: dataGroupId,
            encode: {
              ...encode,
              itemGroupId: 2
            },
            data: data,
            universalTransition: {
              enabled: true,
              divideShape: 'clone'
            }
          },
          ...extraOptions
        };

        const optionWithoutItemGroupId = {
          ...baseOptions,
          ...title,
          series: {
            type: 'bar',
            // id: "sales",
            dataGroupId: dataGroupId,
            encode: {
              ...encode,
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
          ...extraOptions
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
        if (HTMLWidgets.shinyMode){
          Shiny.setInputValue(x.reactiveID, dataGroupId);
        }
      };

      const goBack = () => {
        if (dataGroupIdStack.length === 0) {
          console.log('Already in root dataGroup!');
        } else {
          console.log('Go back to previous level');
          if (HTMLWidgets.shinyMode){
            Shiny.setInputValue(x.reactiveID, dataGroupIdStack.slice(-1)[0]);
          }
          myChart.setOption(allOptionsWithoutItemGroupId[myChart.getOption().series[0].dataGroupId],false);
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
