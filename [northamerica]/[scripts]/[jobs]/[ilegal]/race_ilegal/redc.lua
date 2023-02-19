----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenW, screenH = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- INIT RACE COL
----------------------------------------------------------------------------------------------------------------
function onhitcentralraceilegal(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if getElementData(source, "idilegalrace") and isElement(getElementData(source, "colilegalrace")) then
            targetcolilegalrace = source
            showcolilegalrace = true
            colilegalracesid = getElementData(source,"idilegalrace")
        end
    end
end
addEventHandler("onClientColShapeHit", root, onhitcentralraceilegal)
------------------------------------------------------------
function onleavecolraceilegal(hitElement, dim)
if hitElement ~= localPlayer then return end
if getElementData(source, "idilegalrace") ~= colilegalracesid then return end
  if dim then
      targetcolilegalrace = false
      showcolilegalrace = false
      colilegalracesid = false
	end
end
addEventHandler("onClientColShapeLeave", root, onleavecolraceilegal)
----------------------------------------------------------------------------------------------------------------
-- RACE POINTS
----------------------------------------------------------------------------------------------------------------
local blips = false
local inrace = false
local plyveh = false
local timerace = 0
local racepoint = 1
local racepos = 0 

local races = {
	[1] = {
		['time'] = 130,
		[1] = {174.741, 2504.415, 16.484},
	    [2] = {120.063, 2504.523, 16.484},
		[3] = {-74.527, 2481.985, 16.492},
		[4] = {-191.185, 2501.221, 24.833},
		[5] = {-337.548, 2516.936, 35.4},
		[6] = {-379.255, 2568.847, 40.654},
		[7] = {-395.86, 2642.001, 48.013},
		[8] = {-420.475, 2705.748, 61.964},
		[9] = {-383.783, 2692.487, 64.132},
		[10] = {-266.114, 2699.532, 62.539},
		[11] = {-229.289, 2749.213, 62.539},
		[12] = {-189.209, 2647.738, 63.188},
		[13] = {-126.416, 2633.356, 63.888},
		[14] = {-20.239, 2635.948, 62.791},
		[15] = {125.086, 2719.112, 52.932},
		[16] = {222.74, 2747.704, 59.706},
		[17] = {335.983, 2715.482, 59.844},
		[18] = {406.995, 2698.04, 60.634},
		[19] = {523.406, 2656.999, 48.798},
		[20] = {641.735, 2658.692, 30.937},
		[21] = {734.364, 2657.996, 18.6},
		[22] = {796.602, 2642.834, 14.53},
		[23] = {884.725, 2601.756, 10.668},
		[24] = {1017.236, 2526.986, 10.645},
		[25] = {1099.385, 2469.783, 10.594},
		[26] = {1202.857, 2295.995, 6.746},
		[27] = {1205.723, 2134.718, 6.734},
		[28] = {1205.997, 1977.103, 6.734},
		[29] = {1137.611, 1825.711, 10.648},
		[30] = {1216.742, 1811.137, 13.945},
		[31] = {1285.084, 1810.676, 10.658},
		[32] = {1274.874, 1748.783, 9.449},
		[33] = {1235.919, 1692.944, 6.722},
		[34] = {1211.369, 1638.658, 6.734},
		[35] = {1210.869, 1536.293, 6.734},
		[36] = {1210.658, 1466.494, 6.734},
		[37] = {1223.852, 1378.342, 6.734},
		[38] = {1223.128, 1294.22, 6.734},
		[39] = {1212.072, 1239.082, 6.756},
		[40] = {1211.793, 1162.004, 6.813},
		[41] = {1240.651, 1111.673, 6.775},
		[42] = {1345.176, 976.221, 16.134},
		[43] = {1274.823, 887.751, 15.817},
		[44] = {1145.547, 852.45, 10.964},
		[45] = {1095.637, 832.075, 10.672},
		[46] = {1021.268, 781.459, 10.708},
		[47] = {888.827, 730.082, 10.723},
		[48] = {705.45, 679.291, 9.673},
		[49] = {602.576, 684.075, 4.537},
		[50] = {472.652, 741.189, 4.717},
		[51] = {422.044, 765.946, 5.777},
		[52] = {379.53, 778.329, 6.191},
		[53] = {283.965, 860.666, 19.715},
		[54] = {241.573, 943.358, 27.338},
		[55] = {212.956, 1011.431, 26.195},
	},
	[2] = {
		['time'] = 160,
        [1] = {178.996, 2494.033, 16.278},
        [2] = {10.249, 2490.293, 16.277},
        [3] = {-64.175, 2328.199, 21.795},
        [4] = {125.717, 2287.364, 20.272},
        [5] = {271.379, 2283.676, 24.782},
        [6] = {393.733, 2357.289, 25.078},
        [7] = {519.96, 2344.795, 30.148},
        [8] = {590.661, 2161.225, 38.706},
        [9] = {611.345, 1990.827, 35},
        [10] = {582.331, 1826.769, 13.783},
        [11] = {529.89, 1690.007, 11.19},
        [12] = {434.975, 1620.977, 16.814},
        [13] = {362.819, 1469.691, 7.569},
        [14] = {313.534, 1299.263, 11.965},
        [15] = {190.166, 1159.72, 14.536},
        [16] = {218.388, 982.501, 28.059},
        [17] = {292.972, 813.595, 15.904},
        [18] = {362.501, 681.551, 9.975},
        [19] = {426.917, 601.46, 18.718},
        [20] = {542.618, 436.586, 18.723},
        [21] = {616.492, 323.346, 19.425},
        [22] = {743.04, 318.681, 19.675},
        [23] = {877.466, 350.945, 19.676},
        [24] = {1016.844, 462.339, 19.673},
        [25] = {1088.729, 440.409, 24.004},
        [26] = {1213.06, 356.53, 19.227},
        [27] = {1199.567, 290.88, 19.199},
        [28] = {1278.536, 251.468, 19.193},
        [29] = {1278.536, 251.468, 19.193},
        [30] = {1234.148, 73.896, 22.136},
        [31] = {1290.322, -69.156, 35.567},
        [32] = {1245.692, -119.571, 38.487},
        [33] = {1187.843, -157.729, 40.386},
        [34] = {1218.763, -254.629, 22.909},
        [35] = {1257.75, -404.363, 2.302},
        [36] = {1222.955, -573.689, 45.696},
        [37] = {1174.771, -690.093, 61.902},
        [38] = {1154.198, -891.635, 42.472},
        [39] = {1157.064, -934.165, 42.823},
        [40] = {1093.63, -949.435, 42.421},
        [41] = {1081.115, -1030.579, 31.881},
        [42] = {1154.343, -1041.189, 31.514},
        [43] = {1160.807, -1130.043, 23.494},
        [44] = {1068.498, -1142.393, 23.48},
        [45] = {1055.903, -1191.751, 20.182},
        [46] = {1140.585, -1207.591, 18.751},
    },
    [3] = {
		['time'] = 230,
        [1] = {174.741, 2504.415, 16.484},
        [2] = {120.063, 2504.523, 16.484},
        [3] = {-74.527, 2481.985, 16.492},
        [4] = {-336.389, 2518.677, 35.31},
        [5] = {-457.652, 2448.811, 48.438},
        [6] = {-547.947, 2422.433, 62.949},
        [7] = {-696.65, 2520.294, 75.324},
        [8] = {-725.453, 2584.152, 70.04},
        [9] = {-735.044, 2649.555, 63.518},
        [10] = {-768.205, 2696.021, 47.176},
        [11] = {-803.3, 2731.691, 45.174},
        [12] = {-925.751, 2722.913, 45.661},
        [13] = {-1007.436, 2713.658, 45.661},
        [14] = {-1055.794, 2707.819, 45.661},
        [15] = {-1138.988, 2698.672, 45.668},
        [16] = {-1188.577, 2692.409, 45.661},
        [17] = {-1271.794, 2670.302, 48.529},
        [18] = {-1333.398, 2646.997, 49.986},
        [19] = {-1391.074, 2581.894, 57.136},
        [20] = {-1424.252, 2501.434, 61.69},
        [21] = {-1436.546, 2370.655, 53.087},
        [22] = {-1400.006, 2275.616, 55.039},
        [23] = {-1355.622, 2174.917, 48.491},
        [24] = {-1333.464, 1994.041, 52.566},
        [25] = {-1217.227, 1865.795, 40.656},
        [26] = {-1182.693, 1806.671, 40.484},
        [27] = {-1221.054, 1806.217, 41.253},
        [28] = {-1284.352, 1843.41, 39.282},
        [29] = {-1374.855, 1857.208, 36.899},
        [30] = {-1472.055, 1848.855, 32.353},
        [31] = {-1562.59, 1843.045, 26.944},
        [32] = {-1670.774, 1829.818, 25.593},
        [33] = {-1682.319, 1918.807, 21.292},
        [34] = {-1662.801, 2022.092, 18.542},
        [35] = {-1665.121, 2150.198, 19.893},
        [36] = {-1769.792, 2240.552, 22.758},
        [37] = {-1874.832, 2353.495, 43.2},
        [38] = {-1958.068, 2555.755, 52.369},
        [39] = {-2089.284, 2655.481, 52.26},
        [40] = {-2236.106, 2680.57, 54.326},
        [41] = {-2372.003, 2674.392, 58.719},
        [42] = {-2530.576, 2669.65, 67.335},
        [43] = {-2695.22, 2656.274, 86.136},
        [44] = {-2757.31, 2572.901, 93.956},
        [45] = {-2770.43, 2459.416, 93.763},
        [46] = {-2772.649, 2390.394, 82.294},
        [47] = {-2761.095, 2317.227, 68.594},
        [48] = {-2692.944, 2158.435, 55.223},
        [49] = {-2690.971, 2041.259, 57.089},
        [50] = {-2690.915, 1823.54, 67.398},
        [51] = {-2692.12, 1660.498, 66.358},
        [52] = {-2691.664, 1531.594, 60.251},
        [53] = {-2690.615, 1421.311, 55.224},
        [54] = {-2692.755, 1332.535, 55.224},
        [55] = {-2689.463, 1240.852, 55.223},
        [56] = {-2733.823, 1193.107, 53.487},
        [57] = {-2732.321, 1098.394, 46.177},
        [58] = {-2752.695, 1011.87, 54.125},
        [59] = {-2753.333, 939.943, 54.218},
        [60] = {-2752.665, 889.798, 65.981},
        [61] = {-2752.939, 806.111, 52.763},
        [62] = {-2753.294, 716.72, 40.919},
        [63] = {-2752.93, 635.116, 27.558},
        [64] = {-2753.074, 577.754, 14.288},
        [65] = {-2708.899, 480.271, 4.107},
        [66] = {-2712.329, 386.226, 4.163},
        [67] = {-2708.051, 303.015, 3.973},
        [68] = {-2708.618, 223.403, 3.982},
        [69] = {-2707.809, 138.584, 3.974},
        [70] = {-2707.94, 53.64, 3.973},
        [71] = {-2708.094, -53.019, 3.973},
        [72] = {-2746.484, -67.977, 6.861},
        [73] = {-2756.981, -113.771, 6.687},
        [74] = {-2757.443, -197.425, 6.824},
        [75] = {-2719.057, -212.858, 4.626},
        [76] = {-2666.286, -212.313, 3.973},
        [77] = {-2682.946, -263.503, 6.819},
        [78] = {-2727.389, -307.902, 6.833},
        [79] = {-2801.08, -328.112, 6.831},
        [80] = {-2804.982, -475.335, 6.98},
        [81] = {-2729.35, -526.71, 8.466},
        [82] = {-2673.323, -457.663, 27.887},
        [83] = {-2611.616, -378.333, 41.005},
        [84] = {-2476.205, -371.014, 65.55},
        [85] = {-2361.686, -402.135, 78.59},
        [86] = {-2332.368, -458.836, 79.803},
        [87] = {-2418.778, -414.554, 85.357},
        [88] = {-2502.627, -448.188, 74.927},
        [89] = {-2630.569, -495.931, 69.961},
        [90] = {-2562.971, -494.442, 77.884},
        [91] = {-2491.847, -482.041, 96.087},
        [92] = {-2452.979, -556.073, 124.88},
        [93] = {-2424.539, -609.879, 132.355},
    },
    [4] = {
        ['time'] = 265,
        [1] = {195.497, 2505.671, 16.315},
        [2] = {121.494, 2508.092, 16.337},
        [3] = {44.252, 2526.492, 16.319},
        [4] = {99.223, 2560.083, 16.2},
        [5] = {205.889, 2560.371, 16.2},
        [6] = {350.175, 2560.691, 16.2},
        [7] = {471.587, 2493.696, 22.948},
        [8] = {483.426, 2386.649, 28.833},
        [9] = {553.272, 2312.971, 33.365},
        [10] = {577.083, 2221.146, 35.887},
        [11] = {605.996, 2036.567, 36.069},
        [12] = {577.711, 1814.356, 13.675},
        [13] = {527.787, 1692.754, 11.166},
        [14] = {507.906, 1669.508, 12.903},
        [15] = {511.911, 1640.748, 12.734},
        [16] = {590.486, 1681.042, 6.825},
        [17] = {658.369, 1848.585, 5.305},
        [18] = {803.379, 1812.822, 3.743},
        [19] = {833.586, 1699.809, 5.883},
        [20] = {770.605, 1444.175, 20.233},
        [21] = {829.464, 1182.007, 27.395},
        [22] = {820.247, 1152.319, 27.986},
        [23] = {674.788, 1096.061, 28.181},
        [24] = {536.912, 1059.356, 28.171},
        [25] = {371.678, 1016.335, 28.342},
        [26] = {237.573, 978.141, 28.025},
        [27] = {157.112, 906.734, 21.078},
        [28] = {-54.247, 860.199, 17.575},
        [29] = {-108.137, 833.148, 19.496},
        [30] = {-114.09, 774.738, 20.538},
        [31] = {-258.506, 700.006, 22.215},
        [32] = {-243.317, 616.599, 10.887},
        [33] = {-137.332, 598.338, 1.911},
        [34] = {-143.77, 471.576, 11.91},
        [35] = {-207.521, 231.413, 11.902},
        [36] = {-167.399, 195.057, 10.012},
        [37] = {-48.507, 149.508, 2.837},
        [38] = {108.119, 27.826, 0.333},
        [39] = {17.941, -151.325, 0.333},
        [40] = {-92.778, -128.735, 2.841},
        [41] = {-124.057, -161.354, 2.64},
        [42] = {-101.515, -196.795, 1.492},
        [43] = {55.469, -212.187, 1.178},
        [44] = {147.298, -213.691, 1.153},
        [45] = {170.915, -214.156, 1.152},
        [46] = {206.269, -290.323, 1.148},
        [47] = {452.014, -409.14, 27.965},
        [48] = {569.932, -417.562, 27.216},
        [49] = {638.896, -447.195, 15.911},
        [50] = {600.976, -500.055, 15.909},
        [51] = {664.812, -532.114, 15.913},
        [52] = {678.744, -635.648, 15.911},
        [53] = {711.551, -871.241, 42.973},
        [54] = {793.31, -1024.441, 25.725},
        [55] = {795.905, -1124.519, 23.545},
        [56] = {889.562, -1149.025, 23.509},
        [57] = {1201.252, -1147.755, 23.348},
        [58] = {1325.778, -1148.02, 23.372},
        [59] = {1340.389, -1226.239, 13.821},
        [60] = {1443.259, -1242.949, 13.104},
        [61] = {1452.446, -1345.139, 13.106},
        [62] = {1452.089, -1428.361, 13.106},
        [63] = {1551.591, -1443.305, 13.106},
        [64] = {1649.228, -1443.183, 13.105},
        [65] = {1655.895, -1573.256, 13.106},
        [66] = {1723.709, -1596.825, 13.091},
        [67] = {1841.227, -1614.133, 13.106},
        [68] = {1936.418, -1596.179, 13.272},
        [69] = {1948.813, -1571.017, 13.309},
        [70] = {1990.644, -1593.843, 13.298},
        [71] = {2057.748, -1614.632, 13.106},
        [72] = {2079.159, -1682.349, 13.114},
        [73] = {2082.731, -1747.874, 13.102},
        [74] = {2113.675, -1687.664, 13.104},
        [75] = {2114.614, -1513.47, 23.469},
        [76] = {2143.506, -1497.15, 23.701},
        [77] = {2215.362, -1482.888, 23.548},
        [78] = {2214.845, -1402.189, 23.545},
        [79] = {2298.466, -1386.356, 23.622},
        [80] = {2352.351, -1385.815, 23.558},
    },
    [5] = {
        ["time"] = 170,
        [1] = {166.605, 2505.871, 16.092},
        [2] = {84.57, 2505.572, 16.092},
        [3] = {-34.242, 2490.68, 16.092},
        [4] = {-136.601, 2470.234, 15.317},
        [5] = {-273.022, 2520.76, 33.283},
        [6] = {-347.162, 2516.343, 35.532},
        [7] = {-411.34, 2717.385, 61.803},
        [8] = {-324.354, 2634.164, 63.241},
        [9] = {-180.683, 2633.981, 62.942},
        [10] = {-13.01, 2637.208, 62.137},
        [11] = {124.822, 2718.635, 52.509},
        [12] = {280.729, 2732.248, 59.448},
        [13] = {420.079, 2697.462, 60.308},
        [14] = {576.902, 2716.997, 59.67},
        [15] = {750.812, 2703.821, 49.3},
        [16] = {875.884, 2676.569, 31.539},
        [17] = {863.032, 2548.86, 29.179},
        [18] = {848.358, 2509.097, 29.163},
        [19] = {839.416, 2383.115, 27.91},
        [20] = {728.273, 2351.7, 29.222},
        [21] = {670.668, 2451.79, 31.409},
        [22] = {726.958, 2592.011, 22.904},
        [23] = {857.429, 2612.819, 10.91},
        [24] = {1029.512, 2519.847, 10.243},
        [25] = {1165.312, 2422.453, 10.335},
        [26] = {1294.84, 2364.803, 12.459},
        [27] = {1435.376, 2440.477, 6.474},
        [28] = {1559.622, 2460.344, 6.333},
        [29] = {1722.958, 2422.935, 6.396},
        [30] = {1785.755, 2305.443, 5.566},
        [31] = {1785.451, 2123.074, 3.514},
        [32] = {1786.658, 1883.595, 6.338},
        [33] = {1785.424, 1715.444, 6.342},
        [34] = {1785.354, 1578.377, 6.342},
        [35] = {1785.31, 1482.149, 6.342},
        [36] = {1786.337, 1303.958, 6.341},
        [37] = {1786.323, 1206.549, 6.35},
        [38] = {1785.893, 1077.343, 6.349},
        [39] = {1785.425, 936.247, 7.885},
        [40] = {1785.418, 864.905, 10.246},
        [41] = {1822.321, 835.887, 10.121},
        [42] = {1944.851, 837.406, 6.35},
        [43] = {2057.496, 837.432, 6.344},
        [44] = {2062.5, 942.988, 9.46},
        [45] = {2080.931, 1030.213, 10.326},
        [46] = {2171.389, 1122.984, 12.192},
        [47] = {2189.292, 1195.087, 10.621},
        [48] = {2189.601, 1298.524, 10.278},
        [49] = {2189.368, 1363.498, 10.288},
        [50] = {2250.165, 1385.764, 10.329},
        [51] = {2249.506, 1523.41, 10.29},
        [52] = {2331.477, 1530.533, 10.366},
        [53] = {2417.417, 1530.551, 10.28},
        [54] = {2429.166, 1603.988, 10.346},
        [55] = {2535.622, 1610.405, 10.285},
        [56] = {2549.742, 1689.99, 10.421},
        [57] = {2629.072, 1716.49, 10.629},
    },
    [6] = {
        ["time"] = 175,
        [1] = {160.541, 2506.374, 16.09},
        [2] = {88.079, 2507.457, 16.092},
        [3] = {24.041, 2507.982, 16.096},
        [4] = {-47.413, 2491.519, 16.092},
        [5] = {-126.763, 2467.801, 14.152},
        [6] = {-89.292, 2402.106, 16.044},
        [7] = {-60.549, 2317.81, 22.799},
        [8] = {71.812, 2300.237, 20.67},
        [9] = {280.634, 2282.464, 24.678},
        [10] = {424.221, 2374.916, 25.494},
        [11] = {549.755, 2318.922, 32.721},
        [12] = {590.71, 2175.751, 37.944},
        [13] = {607.725, 2033.484, 35.77},
        [14] = {594.679, 1853.389, 15.216},
        [15] = {540.864, 1746.342, 10.6},
        [16] = {528.51, 1690.297, 11.048},
        [17] = {602.892, 1721.856, 6.554},
        [18] = {653.354, 1815.344, 5.078},
        [19] = {661.881, 1894.845, 5.077},
        [20] = {664.99, 1989.723, 6.85},
        [21] = {673.64, 2166.525, 20.977},
        [22] = {663.817, 2327.626, 26.509},
        [23] = {646.655, 2480.766, 30.75},
        [24] = {732.496, 2597.289, 22.007},
        [25] = {864.417, 2610.962, 10.704},
        [26] = {1005.885, 2535.875, 10.232},
        [27] = {1147.815, 2437.18, 10.219},
        [28] = {1281.517, 2365.117, 13.133},
        [29] = {1390.632, 2423.106, 7.3},
        [30] = {1552.922, 2451.508, 6.342},
        [31] = {1708.031, 2463.002, 6.443},
        [32] = {1855.303, 2495.742, 6.418},
        [33] = {1985.358, 2552.556, 6.4},
        [34] = {2167.536, 2603.023, 6.381},
        [35] = {2286.439, 2611.248, 6.356},
        [36] = {2502.777, 2592.942, 4.472},
        [37] = {2624.735, 2507.45, 5.959},
        [38] = {2700.711, 2366.651, 6.342},
        [39] = {2711.519, 2199.007, 6.35},
        [40] = {2712.007, 2047.262, 6.34},
        [41] = {2712.625, 1893.926, 6.34},
        [42] = {2711.858, 1765.237, 6.341},
        [43] = {2712.674, 1633.727, 6.349},
        [44] = {2669.938, 1550.649, 8.219},
        [45] = {2637.42, 1485.083, 10.236},
        [46] = {2570.322, 1475.748, 10.418},
        [47] = {2551.339, 1526.119, 10.28},
        [48] = {2486.261, 1549.293, 10.277},
        [49] = {2508.99, 1602.258, 10.28},
        [50] = {2477.188, 1615.613, 10.29},
        [51] = {2428.606, 1615.273, 10.625},
        [52] = {2334.651, 1615.294, 10.348},
        [53] = {2324.887, 1543.301, 10.284},
        [54] = {2308.82, 1519.511, 10.426},
        [55] = {2310.043, 1410.273, 10.429},
        [56] = {2281.911, 1397.102, 10.427},
        [57] = {2290.314, 1508.264, 16.824},
        [58] = {2332.89, 1446.122, 20.5},
        [59] = {2294.58, 1396.563, 23.233},
        [60] = {2282.506, 1495.306, 29.12},
        [61] = {2332.488, 1481.094, 31.044},
        [62] = {2321.744, 1398.948, 36.024},
        [63] = {2278.451, 1452.966, 39.213},
        [64] = {2321.004, 1478.607, 42.426},
        [65] = {2321.019, 1394.859, 42.425}
    }
}
----------------------------------------------------------------------------------------------------------------
-- START RACE
----------------------------------------------------------------------------------------------------------------
targetcolilegalrace = false
showcolilegalrace = false
colilegalracesid = false

local ilegalracetacol = {}
local ilegalracetamk = {}
local ilegalracetablip = {}

function startracepoints()
    if getElementData(localPlayer,"openui") == false then
        if isPedInVehicle(localPlayer) then
            if isElement(targetcolilegalrace) then
                if getPedOccupiedVehicleSeat (localPlayer) == 0 then
                    if not inrace then
                        local rcp = tonumber(getElementData(targetcolilegalrace,"racepoint"))
                        if rcp then
                            if getElementData(localPlayer,"Raceticket") < 1 then return end
                            local veh = getPedOccupiedVehicle(localPlayer)
                            plyveh = veh
                            inrace = true
                            racepos = 1
                            racepoint = rcp
                            timerace = races[racepoint].time
                            CriandoBlip(races,racepoint,racepos)
                            exports.an_infobox:addNotification("Você iniciou uma <b>corrida explosiva</b> termine a tempo ou o seu carro será explodido!","info")
                            triggerServerEvent("plyinitrage", localPlayer,localPlayer)
                            exports.an_inventory:attitem("Raceticket","1","menos")
                            setElementData(localPlayer,"inilegalrace",true)
                        end
                    end
                end
            end
        end
    end
end
bindKey("H", "down", startracepoints)

function checkPoint()
    if inrace then
        local dist = getproxyonply(9)
        if dist then
            if racepos == #races[racepoint] then
                inrace = false
                finishanddestroy()
                triggerServerEvent("paymentply_ilegalrace", localPlayer,localPlayer,racepoint)
                setElementData(localPlayer,"inilegalrace",nil)
            else
                racepos = racepos + 1
                CriandoBlip(races,racepoint,racepos)
            end
        end
    end
end
addEventHandler("onClientRender",root,checkPoint)
----------------------------------------------------------------------------------------------------------------
-- CHECKPOINTS
----------------------------------------------------------------------------------------------------------------
function CriandoBlip(races,racepoint,racepos)
    local plyid = getElementData(localPlayer,"id")
    if isElement(ilegalracetamk) then
        destroyElement(ilegalracetamk)
        destroyElement(ilegalracetablip)
        ilegalracetablip = createBlip (races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3], 2, 2, 200, 0, 0, 255, 1, 7500)
        ilegalracetamk = createMarker(races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3]-1, "checkpoint", 6, 255, 255, 255, 5)
        exports.an_radar:makeRoute(races[racepoint][racepos][1],races[racepoint][racepos][2],true) 
    elseif not isElement(ilegalracetamk) then
        ilegalracetablip = createBlip (races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3], 2, 2, 200, 0, 0, 255, 1, 7500)
        ilegalracetamk = createMarker(races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3]-1, "checkpoint", 6, 255, 255, 255, 5)
        exports.an_radar:makeRoute(races[racepoint][racepos][1],races[racepoint][racepos][2],true) 
    end
end

function finishanddestroy()
    if isElement(ilegalracetamk) then
        destroyElement(ilegalracetamk)
        destroyElement(ilegalracetablip)
    end
end

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    if isElement(ilegalracetamk) then
        if getDistanceBetweenPoints3D ( pX, pY, pZ, races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3]) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3])
            id = true
        end
    end
    if id then
        return id
    else
        return false
    end
end
----------------------------------------------------------------------------------------------------------------
-- RACE NUI
----------------------------------------------------------------------------------------------------------------
function dxtratamentmdcmaca ()
    if inrace and timerace > 0 then
        dxDrawColorText("#edededRESTAM #4c98ff"..timerace.." #edededSEGUNDOS PARA CHEGAR AO DESTINO FINAL DA CORRIDA", screenW * 0.3294, screenH * 0.9128, screenW * 0.6698, screenH * 0.9414, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
        dxDrawColorText("#edededVENÇA A CORRIDA E SUPERE SEUS PROPRIOS RECORDES ANTES DO TEMPO ACABAR", screenW * 0.3294, screenH * 0.9414, screenW * 0.6698, screenH * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
        if ilegalracetamk then
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(races[racepoint][racepos][1],races[racepoint][racepos][2],races[racepoint][racepos][3], 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#3b8ff7CHECKPOINT", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    end
end
addEventHandler ("onClientRender", root, dxtratamentmdcmaca)
----------------------------------------------------------------------------------------------------------------
-- TIMERACE
----------------------------------------------------------------------------------------------------------------
function racetimetread()
    if inrace and timerace > 0 then
        timerace = timerace - 1
        if timerace <= 0 or not isPedInVehicle(localPlayer) then
                inrace = false
                finishanddestroy()
            if plyveh then
                local getvehf = getElementData(plyveh,"fuel")
                setVehicleEngineState(plyveh,false)
                setElementData(plyveh, "fuel", getElementData(plyveh, "fuel") - getvehf) 
                setElementData(plyveh, "Nitrous", 0)
                setTimer(function()
                    blowVehicle (plyveh)
                end,1000*2,1)
            end
                setElementData(localPlayer,"inilegalrace",nil)
                exports.an_infobox:addNotification("Você não terminou a corrida a tempo, o seu veiculo foi sabotado!","erro")
                triggerServerEvent("destroyplyblip", localPlayer, localPlayer)
        end
    end
setTimer(racetimetread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), racetimetread)

----------------------------------------------------------------------------------------------------------------
-- BLIPS
----------------------------------------------------------------------------------------------------------------
local plyblips = {}
local plyblips2 = {}

function bliprace(plyracer)
    if not isElement(plyblips[plyracer]) then
        plyblips[plyracer] = createBlipAttachedTo(plyracer, 2, 2, 255, 200, 0, 255, 50, 700)
    end
end
addEvent ("bliprace", true)
addEventHandler ("bliprace", root, bliprace)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destoyilraceblip(ply)
  if isElement(plyblips[ply]) then
    destroyElement(plyblips[ply])
  end
  if isElement(plyblips2[ply]) then
    destroyElement(plyblips2[ply])
  end
end
addEvent ("destoyilraceblip", true)
addEventHandler ("destoyilraceblip", root, destoyilraceblip)

setElementData(localPlayer,"inilegalrace",nil)
function racerplyblips()
    for k,v in ipairs(getElementsByType("player")) do
        if getElementData(v, "inilegalrace") then 
            if not isElement(plyblips2[v]) then
                plyblips2[v] = createBlipAttachedTo(v, 2, 2, 255, 200, 0, 255, 50, 700)
            end
        else
            if isElement(plyblips2[v]) then
                destroyElement(plyblips2[v])
            end
        end
        if not getElementData(localPlayer, "inilegalrace") then 
            if isElement(plyblips2[v]) then
            destroyElement(plyblips2[v])
            end
            for k,v in ipairs(getElementsByType("player")) do
                if getElementData(v, "inilegalrace") then 
                    if isElement(plyblips2[v]) then
                        destroyElement(plyblips2[v])
                    end
                end
            end
        end
    end
  setTimer(racerplyblips,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), racerplyblips)
----------------------------------------------------------------------------------------------------------------
-- VARIAEIS
----------------------------------------------------------------------------------------------------------------
function getFormatSpeed(ply)
  local speedes = (getVehicleVelocity((getPedOccupiedVehicle(ply)))) * 1.558
  return speedes
end
function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	return relateVelocity((speedx^2 + speedy^2 + speedz^2)^ 0.5 * 100)
end
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
local factor = 0.675
function relateVelocity(speed)
	return factor * speed
end 
--------------------------------------------------------------------
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if 
        type( sEventName ) == 'string' and 
        isElement( pElementAttachedTo ) and 
        type( func ) == 'function' 
    then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
  
    return false
end
--------------------------------------------------------------------
function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY)
    bx, by, color, scale, font = bx or ax, by or ay, color or tocolor(255,255,255,255), scale or 1, font or Font_5
    if alignX then
      if alignX == "center" then
        ax = ax + (bx - ax - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font))/2
      elseif alignX == "right" then
        ax = bx - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
      end
    end
    if alignY then
      if alignY == "center" then
        ay = ay + (by - ay - dxGetFontHeight(scale, font))/2
      elseif alignY == "bottom" then
        ay = by - dxGetFontHeight(scale, font)
      end
    end
     local clip = false
     if dxGetTextWidth(str:gsub("#%x%x%x%x%x%x","")) > bx then clip = true end
    local alpha = string.format("%08X", color):sub(1,2)
    local pat = "(.-)#(%x%x%x%x%x%x)"
    local s, e, cap, col = str:find(pat, 1)
    local last = 1
    local text = ""
    local broke = false
    while s do
      if cap == "" and col then color = tocolor(getColorFromString("#"..col..alpha)) end
      if s ~= 1 or cap ~= "" then
        local w = dxGetTextWidth(cap, scale, font)
             if clip then
                  local text_ = ""
                   for i = 1,string.len(cap) do
                    if dxGetTextWidth(text,scale,font) < bx then
                    text = text..""..string.sub(cap,i,i)
                    text_ = text_..""..string.sub(cap,i,i)
                    else
                    broke = true
                     break
                    end
                   end
                   cap = text_
                  end
        dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
        ax = ax + w
        color = tocolor(getColorFromString("#"..col..alpha))
      end
      last = e + 1
      s, e, cap, col = str:find(pat, last)
    end
    if last <= #str and not broke then
      cap = str:sub(last)
                     if clip then
                  local text_ = ""
                   for i = 1,string.len(cap) do
                    if dxGetTextWidth(text,scale,font) < bx then
                    text = text..""..string.sub(cap,i,i)
                    text_ = text_..""..string.sub(cap,i,i)
                    else
                    broke = true
                     break
                    end
                   end
                   cap = text_
                  end
      dxDrawText(cap, ax, ay, ax + dxGetTextWidth(cap, scale, font), by, color, scale, font)
    end
  end