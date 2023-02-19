cfg = {}
cfg.blipsnameandfouder = {}

cfg.statcsblips = {
         -- blip fouder --- blip pos                -- size -- viz -- color
        {"blips/north.png", 733.1318359375, 3700.951171875, -200, 10, true, tocolor(255, 255, 255)}, -- north

    -------------------------------------------------------------- BANK
        {"blips/bank.png", 2400.716, -1912.553, 14.547, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", 1418.415, -1580.952, 14.547, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", 1080.117, 1744, 11.936, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", 2597.445, 1085.343, 11.52, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", 387.928, -1864.376, 8.836, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", 1669.081, 1455.125, 11.473, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", -2017.7, 438.5, 36, 15, false, tocolor(0, 80, 0), "NA Bank"},
        {"blips/bank.png", -2777.9, 376.5, 7.7, 15, false, tocolor(0, 180, 180), "Central Bank"},
    -------------------------------------------------------------- DEPARTAMENTS
        {"blips/departament.png", 888.739, 2002.868, 10.97, 15, false, tocolor(0, 150, 0), "Market"},
        {"blips/departament.png", 1313.646, -897.353, 39.7, 15, false, tocolor(0, 150, 0), "Market"},
        {"blips/departament.png", -2390.036, -58.222, 35.32, 15, false, tocolor(0, 150, 0), "Market"},
    -------------------------------------------------------------- CLOTH SHOP
        {"blips/clothshop.png", -1986.138, 375.042, 35.3, 15, false, tocolor(0, 0, 255), "Clothes shop"},
        {"blips/clothshop.png", 2098.149, 2209.25, 10.9, 15, false, tocolor(0, 0, 255), "Clothes shop"},
        {"blips/clothshop.png", 930.638, -1680.532, 13.6, 15, false, tocolor(0, 0, 255), "Clothes shop"},
    -------------------------------------------------------------- DEALERSHIP
        {"blips/dealership.png", 1060.685, 1735.096, 10.936, 25, false, tocolor(255, 255, 255), "Super Autos Dealership"},
    -------------------------------------------------------------- HP
        {"blips/ams.png", 1471.778, 2341.156, 22.798, 25, false, tocolor(255, 255, 255), "American Medical Hospital"},
    -------------------------------------------------------------- Tattoos
        {"blips/tatoo.png", 1020.992, 2339.149, 10.9, 15, false, tocolor(255, 255, 255), "Tattoos"},
        {"blips/tatoo.png", 984.625, -1586.018, 13.586, 15, false, tocolor(255, 255, 255), "Tattoos"},
        {"blips/tatoo.png", -2020.25, 388.37, 35.2, 15, false, tocolor(255, 255, 255), "Tattoos"},
    -------------------------------------------------------------- Barber salon
        {"blips/barber.png", -1984.418, 329.301, 10.9, 15, false, tocolor(255, 255, 0), "Barber Salon"},
        {"blips/barber.png", 2229.795, 957.146, 13.586, 15, false, tocolor(255, 255, 0), "Barber Salon"},
        {"blips/barber.png", 1291.644, -1870.815, 35.2, 15, false, tocolor(255, 255, 0), "Barber Salon"},
    -------------------------------------------------------------- Police DP
        {"blips/policedp.png", 1410.251, -1610.436, 13.6, 20, false, tocolor(255, 255, 255), "Police Departament"},
        {"blips/12.png", 1382.406, -1652.7, 13.6, 20, false, tocolor(255, 255, 255), "Pátio"},
    -------------------------------------------------------------- Gas Monkey
        {"blips/oficina.png", 2089.662, 2075.294, 10.9, 25, false, tocolor(255, 255, 255), "Gas Monkey Garage - Workshop"},
    -------------------------------------------------------------- Ikea
        {"blips/7.png", 2638.435, 1110.298, 20.082, 25, false, tocolor(255, 255, 0, 200), "Ikea - Home Furnishings"},
    -------------------------------------------------------------- House
        {"blips/house.png", 2488.454, 974.853, 10.87, 15, false, tocolor(255, 255, 255), "House perimeter"},
        {"blips/house.png", 1672.402, 720.082, 10.87, 15, false, tocolor(255, 255, 255), "House perimeter"},
        {"blips/house.png", 665.988, -1499.006, 10.87, 15, false, tocolor(255, 255, 255), "House perimeter"},
        {"blips/house.png", 2980.564, -663.424, 10.87, 15, false, tocolor(255, 255, 255), "House perimeter"},
    -------------------------------------------------------------- Bus JOB
        {"blips/2.png", 1281.894, -1818.023, 13.383, 15, false, tocolor(0, 0, 255), "Job - Bus Driver"},
    -------------------------------------------------------------- Fishing job
        {"blips/1.png", -390.796, 294.011, 1.801, 15, false, tocolor(255, 255, 255, 255), "Fishing - Point"},
        {"blips/1.png", 381.407, -2088.792, 7.836, 15, false, tocolor(255, 255, 255, 255), "Fishing - Point"},
        {"blips/1.png", -82.93, -1202.935, 2.891, 15, false, tocolor(0, 200, 0, 200), "Fishing - Sell"},
    -------------------------------------------------------------- truck JOB
        {"blips/5.png", -18.221, -279.088, 5.43, 15, false, tocolor(170, 170, 170), "Job - Truck Driver"},
    -------------------------------------------------------------- truck JOB
        {"blips/8.png", 262.999, 1133.809, 15.719, 15, false, tocolor(255, 255, 255), "Job - Milkman"},
    -------------------------------------------------------------- GANG ZONES
        {"blips/4.png", 2488.81, -1670.713, 13.336, 15, false, tocolor(0, 180, 0), "Grove Street"},
        {"blips/4.png", 2544.278, -1044.589, 68.718, 15, false, tocolor(230, 230, 0), "Los Vagos"},
        {"blips/4.png", 1792.447, -2114.996, 15.419, 15, false, tocolor(0, 180, 255), "Varrios Los Aztecas"},
        {"blips/4.png", 2449.733, -1338.356, 29.211, 15, false, tocolor(100, 0, 200), "Ballas"},
    -------------------------------------------------------------- Fuel Station
        {"blips/9.png", -90.413, -1168.103, 7.744, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 1000.349, -936.476, 48.212, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 1922.614, -1776.142, 17.977, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 2113.929, 918.982, 17.055, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 655.931, -570.577, 16.501, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", -2411.1, 982.94, 45.461, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", -1327.683, 2685.8, 50.469, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 68.1, 1221.098, 19.141, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 2207.7, 2470.0, 10.995, 15, false, tocolor(255, 255, 255), "Fuel Station"},
        {"blips/9.png", 1591.085, 2193.7, 11.061, 15, false, tocolor(255, 255, 255), "Fuel Station"},
    -------------------------------------------------------------- Tool store
        {"blips/toolstore.png", 971.786, 2117.245, 10.82, 15, false, tocolor(0, 150, 255), "Tool Store"},
    -------------------------------------------------------------- Utils store
        {"blips/utilsstore.png", 971.565, 2142.259, 10.82, 15, false, tocolor(150, 0, 0), "Utilities Store"},
    -------------------------------------------------------------- Utils store
        {"blips/7.png", 971.824, 2163.253, 10.82, 20, false, tocolor(255, 255, 255), "Recycling"},
    -------------------------------------------------------------- Wc
        {"blips/wc.png", 2510.88, 1227.066, 10.845, 25, false, tocolor(31, 154, 255), "West Coast"},
    -------------------------------------------------------------- PHONE
        {"blips/14.png", 1712.926, 913.335, 10.82, 15, false, tocolor(255, 255, 255), "Shafted Appliances"},

}


cfg.blipconfignames = {

}

cfg.blipsnameandfouder = {
    { "blips/3.png", 2},
    { "blips/10.png", 0},
    { "blips/13.png", 5},
}


