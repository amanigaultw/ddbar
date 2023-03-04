HTMLWidgets.widget({

	name: 'ddbar',

	type: 'output',

	factory: function(el, width, height) {

		var myChart = null;

		return {

			renderValue: function(x) {

				var option;
				var allDataGroups;
				var dataGroupIdStack;
				var allOptionsWithItemGroupId;
				var allOptionsWithoutItemGroupId;
				var extraOptions;
				var xAxis;
				var yAxis;
				var encode;

				var reset = () => {

					if (myChart === null) {
						myChart = echarts.init(document.getElementById(el.id));
					} else {
						myChart.dispose(document.getElementById(el.id));
						myChart = echarts.init(document.getElementById(el.id));
					}

					allDataGroups = x.data;
					extraOptions = x.options;

					xAxis = {
						type: 'category'
					};
					yAxis = {};
					encode = {
						x: 0,
						y: 1,
					};
					if (x.flip === "TRUE") {
						xAxis = {};
						yAxis = {
							type: 'category'
						};
						encode = {
							x: 1,
							y: 0,
						};
					}

					// A stack to remember previous dataGroupsId
					dataGroupIdStack = [];

					// Generate 1+1 options for each data
					allOptionsWithItemGroupId = {};
					allOptionsWithoutItemGroupId = {};

					allDataGroups.forEach((dataGroup, index) => {
						var {
							dataGroupId,
							data
						} = dataGroup;

						var baseOptions = {
							xAxis: xAxis,
							yAxis: yAxis,
							graphic: [{
								type: 'text',
								left: 50,
								top: 20,
								style: {
									text: 'Back',
									fontSize: 18
								},
								onclick: function() {
									goBack();
								}
							}],
							animationDurationUpdate: 500,
						}

						var title = {
							title: {
								text: dataGroupId,
								left: "center",
								top: "bottom",
								textStyle: {
									fontSize: 20
								}
							}
						};

						if (x.showTitle === "FALSE") {
							title.title.text = "";
						}

						var optionWithItemGroupId = {
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

						var optionWithoutItemGroupId = {
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

					var goForward = (dataGroupId) => {
						dataGroupIdStack.push(myChart.getOption().series[0].dataGroupId); // push current dataGroupId into stack.
						myChart.setOption(allOptionsWithoutItemGroupId[dataGroupId], false);
						myChart.setOption(allOptionsWithItemGroupId[dataGroupId], false); // setOption twice? Yeah, it is dirty.
						if (HTMLWidgets.shinyMode) {
							Shiny.setInputValue(x.reactiveID, dataGroupId);
						}
					};

					var goBack = () => {
						if (dataGroupIdStack.length === 0) {
							console.log('Already in root dataGroup!');
						} else {
							console.log('Go back to previous level');
							if (HTMLWidgets.shinyMode) {
								Shiny.setInputValue(x.reactiveID, dataGroupIdStack.slice(-1)[0]);
							}
							myChart.setOption(allOptionsWithoutItemGroupId[myChart.getOption().series[0].dataGroupId], false);
							myChart.setOption(allOptionsWithItemGroupId[dataGroupIdStack.pop()], true); // Note: the parameter notMerge is set true
						}
					};

					myChart.on('click', 'series.bar', (params) => {
						if (params.data[2]) {
							// If current params is not belong to the "childest" data, then it has data[2]
							var dataGroupId = params.data[2];
							goForward(dataGroupId);
						}
					});

					option = allOptionsWithItemGroupId['']; // The initial option is the root data option

					option && myChart.setOption(option, true);

				}

				reset();

			},

			resize: function(width, height) {

				if (!myChart)
					return;

				myChart.resize({
					width: width,
					height: height
				});

			}

		};
	}
});
