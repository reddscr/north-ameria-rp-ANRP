cfg = {}

cfg.armarioobjecttable = {
    {1741}
}


cfg.tradelocals = {
    { 1, -2344.311, -107.47, 30.334, 'buy'}, -- mafia fabrica de arms
    --[[{ 2, 1064.93, 1794.565, 10.82 }, -- pant shop]]
    ------------------------------------ walmarto
    { 3, 888.739, 2002.868, 10.97, 'buy' },
    { 4, 1313.646, -897.353, 39.7, 'buy' },
    { 5, -2390.036, -58.222, 35.32, 'buy' },
    ------------------------------------
    { 8, 2371.987, 2760.149, 10.82, 'buy'}, --- ilegal loja
    { 9, 971.786, 2117.245, 10.82, 'buy'}, --- tool loja
    { 10, 971.565, 2142.259, 10.82, 'buy'}, --- util loja
    ------------------------------------ west coast
    { 11, 2491.76, 1208.145, 10.845, 'buy'}, 
    { 12, 2487.071, 1206.752, 10.845, 'buy'}, 
    ------------------------------------ HP
    { 13, 1441.59, 2353.559, 17.597, 'buy'}, 
    ------------------------------------ Recycling
    { 14, 971.63, 2163.393, 10.82, 'saller'}, 

    { 15, 1713.093, 913.256, 10.82, 'buy'}, 
    
   
}

--- pra remover listagem colocar ( nil ) no lugar dos nomes e quantidades

cfg.traderitens = {
    [1] = {
        ['item'] = {
            {
                ['titem'] = 'pistol',
                ['titemreq'] = {
                    {17,'Copper'},
                    {16,'Steel'},
                    {15,'Plastic'},
                    {10,'Iron'},
                    {7,'Circuit'},
                    ['titemreqtext'] = '17<s>x</s> Cobre : 16<s>x</s> Aço : 15<s>x</s> Plastico : 10<s>x</s> Ferro : 7<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'AK103',
                ['titemreq'] = {
                    {35,'Copper'},
                    {25,'Steel'},
                    {25,'Plastic'},
                    {30,'Aluminum'},
                    {25,'Circuit'},
                    ['titemreqtext'] = '35<s>x</s> Cobre : 25<s>x</s> Aço : 25<s>x</s> Plastico : 30<s>x</s> Alumínio : 25<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'winchester22',
                ['titemreq'] = {
                    {25,'Copper'},
                    {20,'Steel'},
                    {17,'Plastic'},
                    {25,'Iron'},
                    {15,'Circuit'},
                    ['titemreqtext'] = '25<s>x</s> Cobre : 20<s>x</s> Aço : 17<s>x</s> Plastico : 25<s>x</s> Ferro : 15<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'pistolammu',
                ['titemreq'] = {
                    {1,'Copper'},
                    {1,'Gunpowder'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '1<s>x</s> Cobre : 1<s>x</s> Pólvora'
                }
            },
            {
                ['titem'] = 'AK103ammu',
                ['titemreq'] = {
                    {1,'Aluminum'},
                    {1,'Gunpowder'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '1<s>x</s> Alumínio : 1<s>x</s> Pólvora'
                }
            },
            {
                ['titem'] = 'winchester22ammu',
                ['titemreq'] = {
                    {1,'Steel'},
                    {1,'Gunpowder'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '1<s>x</s> Aço : 1<s>x</s> Pólvora'
                }
            },
        },
    },
    [3] = {
        ['item'] = {
            {
                ['titem'] = 'Burguer',
                ['titemreq'] = {
                    {30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Donut',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Taco',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 25'
                }
            },
            {
                ['titem'] = 'Hotdog',
                ['titemreq'] = {
                    {15,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 15'
                }
            },
            {
                ['titem'] = 'Waterbottle',
                ['titemreq'] = {
                    { 30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Energeticdrink',
                ['titemreq'] = {
                    { 200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Cerveja',
                ['titemreq'] = {
                    { 50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 50'
                }
            },
            {
                ['titem'] = 'Tequila',
                ['titemreq'] = {
                    { 100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 100'
                }
            },
            {
                ['titem'] = 'Vodka',
                ['titemreq'] = {
                    { 60,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 60'
                }
            },
            {
                ['titem'] = 'Whisky',
                ['titemreq'] = {
                    { 70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
        }
    },
    [4] = {
        ['item'] = {
            {
                ['titem'] = 'Burguer',
                ['titemreq'] = {
                    {30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Donut',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Taco',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 25'
                }
            },
            {
                ['titem'] = 'Hotdog',
                ['titemreq'] = {
                    {15,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 15'
                }
            },
            {
                ['titem'] = 'Waterbottle',
                ['titemreq'] = {
                    { 30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Energeticdrink',
                ['titemreq'] = {
                    { 200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Cerveja',
                ['titemreq'] = {
                    { 50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 50'
                }
            },
            {
                ['titem'] = 'Tequila',
                ['titemreq'] = {
                    { 100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 100'
                }
            },
            {
                ['titem'] = 'Vodka',
                ['titemreq'] = {
                    { 60,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 60'
                }
            },
            {
                ['titem'] = 'Whisky',
                ['titemreq'] = {
                    { 70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
        }
    },
    [5] = {
        ['item'] = {
            {
                ['titem'] = 'Burguer',
                ['titemreq'] = {
                    {30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Donut',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Taco',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 25'
                }
            },
            {
                ['titem'] = 'Hotdog',
                ['titemreq'] = {
                    {15,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 15'
                }
            },
            {
                ['titem'] = 'Waterbottle',
                ['titemreq'] = {
                    { 30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Energeticdrink',
                ['titemreq'] = {
                    { 200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Cerveja',
                ['titemreq'] = {
                    { 50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 50'
                }
            },
            {
                ['titem'] = 'Tequila',
                ['titemreq'] = {
                    { 100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 100'
                }
            },
            {
                ['titem'] = 'Vodka',
                ['titemreq'] = {
                    { 60,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 60'
                }
            },
            {
                ['titem'] = 'Whisky',
                ['titemreq'] = {
                    { 70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
        }
    },
    [6] = {
        ['item'] = {
            {
                ['titem'] = 'Burguer',
                ['titemreq'] = {
                    {30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Donut',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Taco',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 25'
                }
            },
            {
                ['titem'] = 'Hotdog',
                ['titemreq'] = {
                    {15,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 15'
                }
            },
            {
                ['titem'] = 'Waterbottle',
                ['titemreq'] = {
                    { 30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Energeticdrink',
                ['titemreq'] = {
                    { 200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Cerveja',
                ['titemreq'] = {
                    { 50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 50'
                }
            },
            {
                ['titem'] = 'Tequila',
                ['titemreq'] = {
                    { 100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 100'
                }
            },
            {
                ['titem'] = 'Vodka',
                ['titemreq'] = {
                    { 60,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 60'
                }
            },
            {
                ['titem'] = 'Whisky',
                ['titemreq'] = {
                    { 70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
        }
    },
    [7] = {
        ['item'] = {
            {
                ['titem'] = 'Burguer',
                ['titemreq'] = {
                    {30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Donut',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Taco',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 25'
                }
            },
            {
                ['titem'] = 'Hotdog',
                ['titemreq'] = {
                    {15,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 15'
                }
            },
            {
                ['titem'] = 'Waterbottle',
                ['titemreq'] = {
                    { 30,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 30'
                }
            },
            {
                ['titem'] = 'Energeticdrink',
                ['titemreq'] = {
                    { 200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Cerveja',
                ['titemreq'] = {
                    { 50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 50'
                }
            },
            {
                ['titem'] = 'Tequila',
                ['titemreq'] = {
                    { 100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 100'
                }
            },
            {
                ['titem'] = 'Vodka',
                ['titemreq'] = {
                    { 60,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 60'
                }
            },
            {
                ['titem'] = 'Whisky',
                ['titemreq'] = {
                    { 70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
        }
    },
    [8] = {
        ['item'] = {
            {
                ['titem'] = 'Lockpick',
                ['titemreq'] = {
                    {10,'Steel'},
                    {5,'Plastic'},
                    {10,'Aluminum'},
                    {5,'Rubber'},
                    {nil,nil},
                    ['titemreqtext'] = '10<s>x</s> Aço : 5<s>x</s> Plastico : 10<s>x</s> Alimínio : 5<s>x</s> Borracha'
                }
            },
            {
                ['titem'] = 'faca',
                ['titemreq'] = {
                    {12,'Steel'},
                    {7,'Iron'},
                    {5,'Plastic'},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '12<s>x</s> Aço : 7<s>x</s> Ferro : 5<s>x</s> Plastico'
                }
            },
            {
                ['titem'] = 'Algema',
                ['titemreq'] = {
                    {8,'Steel'},
                    {1,'Iron'},
                    {3,'Plastic'},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '8<s>x</s> Aço : 1<s>x</s> Ferro : 3<s>x</s> Plastico'
                }
            },
            {
                ['titem'] = 'pistol',
                ['titemreq'] = {
                    {27,'Copper'},
                    {20,'Steel'},
                    {17,'Plastic'},
                    {20,'Iron'},
                    {15,'Circuit'},
                    ['titemreqtext'] = '27<s>x</s> Cobre : 20<s>x</s> Aço : 17<s>x</s> Plastico : 20<s>x</s> Ferro : 15<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'pistolammu',
                ['titemreq'] = {
                    {2,'Copper'},
                    {1,'Steel'},
                    {1,'Gunpowder'},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '2<s>x</s> Cobre : 1<s>x</s> Aço : 1<s>x</s> Pólvora'
                }
            },
            {
                ['titem'] = 'winchester22',
                ['titemreq'] = {
                    {40,'Copper'},
                    {25,'Steel'},
                    {16,'Plastic'},
                    {20,'Iron'},
                    {20,'Circuit'},
                    ['titemreqtext'] = '40<s>x</s> Cobre : 25<s>x</s> Aço : 16<s>x</s> Plastico : 20<s>x</s> Ferro : 20<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'winchester22ammu',
                ['titemreq'] = {
                    {1,'Copper'},
                    {2,'Steel'},
                    {1,'Gunpowder'},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '1<s>x</s> Cobre : 2<s>x</s> Aço : 1<s>x</s> Pólvora'
                }
            },
            {
                ['titem'] = 'Pendrive',
                ['titemreq'] = {
                    {1,'Circuit'},
                    {3,'Plastic'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '1<s>x</s> Circuito : 3<s>x</s> Plastico'
                }
            },
            {
                ['titem'] = 'Dynamit',
                ['titemreq'] = {
                    {5,'Gunpowder'},
                    {5,'Plastic'},
                    {2,'Circuit'},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '5<s>x</s> Pólvora : 5<s>x</s> Plastico : 2<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'Canabisseed',
                ['titemreq'] = {
                    {75,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$75'
                }
            },
        }
    },
    [9] = {
        ['item'] = {
            {
                ['titem'] = 'Copper',
                ['titemreq'] = {
                    {150,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 150'
                }
            },
            {
                ['titem'] = 'Steel',
                ['titemreq'] = {
                    {200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Plastic',
                ['titemreq'] = {
                    {70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
            {
                ['titem'] = 'Iron',
                ['titemreq'] = {
                    {150,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 150'
                }
            },
            {
                ['titem'] = 'Circuit',
                ['titemreq'] = {
                    {250,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 250'
                }
            },
            {
                ['titem'] = 'Aluminum',
                ['titemreq'] = {
                    {150,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 150'
                }
            },
            {
                ['titem'] = 'Glass',
                ['titemreq'] = {
                    {70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 70'
                }
            },
            {
                ['titem'] = 'Rubber',
                ['titemreq'] = {
                    {140,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 140'
                }
            },
            {
                ['titem'] = 'Gunpowder',
                ['titemreq'] = {
                    {200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 200'
                }
            },
            {
                ['titem'] = 'Paper',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Cloth',
                ['titemreq'] = {
                    {50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 50'
                }
            },
            {
                ['titem'] = 'Pills',
                ['titemreq'] = {
                    {150,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 150'
                }
            },
        }
    },
    [10] = {
        ['item'] = {
            {
                ['titem'] = 'Repairkit',
                ['titemreq'] = {
                    {10,'Copper'},
                    {15,'Steel'},
                    {15,'Plastic'},
                    {10,'Iron'},
                    {8,'Circuit'},
                    ['titemreqtext'] = '10<s>x</s> Cobre : 15<s>x</s> Aço : 15<s>x</s> Plastico : 10<s>x</s> Ferro : 8<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'Isca',
                ['titemreq'] = {
                    {20,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 20'
                }
            },
            {
                ['titem'] = 'Varadpesca',
                ['titemreq'] = {
                    {500,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 500'
                }
            },
            {
                ['titem'] = 'Mask',
                ['titemreq'] = {
                    {10,'Plastic'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '10<s>x</s> Plastico'
                }
            },
            {
                ['titem'] = 'Smallbackpack',
                ['titemreq'] = {
                    {2000,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 2000'
                }
            },
            {
                ['titem'] = 'Largebackpack',
                ['titemreq'] = {
                    {5000,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 5000'
                }
            },
            {
                ['titem'] = 'Garrafa',
                ['titemreq'] = {
                    {5,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 5'
                }
            },
            {
                ['titem'] = 'Alianca',
                ['titemreq'] = {
                    {3,'Steel'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '3<s>x</s> Aço'
                }
            },
            {
                ['titem'] = 'Yeast',
                ['titemreq'] = {
                    {10,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$ 10'
                }
            },
            {
                ['titem'] = 'Plantpot',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$25'
                }
            },
        }
    },
    [11] = {
        ['item'] = {
            {
                ['titem'] = 'Raceticket',
                ['titemreq'] = {
                    {5,'Paper'},
                    {2,'Plastic'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '5<s>x</s> Paper : 2<s>x</s> Plastico'
                }
            },
        }
    },
    [12] = {
        ['item'] = {
            {
                ['titem'] = 'Nitro',
                ['titemreq'] = {
                    {10,'Copper'},
                    {10,'Steel'},
                    {4,'Plastic'},
                    {2,'Aluminum'},
                    {2,'Circuit'},
                    ['titemreqtext'] = '10<s>x</s> Cobre : 10<s>x</s> Aço : 4<s>x</s> Plastico : 2<s>x</s> Aluminum : 2<s>x</s> Circuito'
                }
            },
            {
                ['titem'] = 'Repairkit',
                ['titemreq'] = {
                    {5,'Copper'},
                    {6,'Steel'},
                    {5,'Plastic'},
                    {5,'Iron'},
                    {2,'Circuit'},
                    ['titemreqtext'] = '5<s>x</s> Cobre : 6<s>x</s> Aço : 5<s>x</s> Plastico : 5<s>x</s> Ferro : 2<s>x</s> Circuito'
                }
            },
        }
    },
    [13] = {
        ['item'] = {
            {
                ['titem'] = 'Bandaid',
                ['titemreq'] = {
                    {1,'Cloth'},
                    {1,'Pills'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '1<s>x</s> Pano : 1<s>x</s> Pílula'
                }
            },
        }
    },
    [14] = {
        ['item'] = {
            
            {
                ['titem'] = 'Copper',
                ['titemreq'] = {
                    {75,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$75'
                }
            },
            {
                ['titem'] = 'Steel',
                ['titemreq'] = {
                    {100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$100'
                }
            },
            {
                ['titem'] = 'Plastic',
                ['titemreq'] = {
                    {35,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$35'
                }
            },
            {
                ['titem'] = 'Iron',
                ['titemreq'] = {
                    {75,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$75'
                }
            },
            {
                ['titem'] = 'Circuit',
                ['titemreq'] = {
                    {125,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$125'
                }
            },
            {
                ['titem'] = 'Aluminum',
                ['titemreq'] = {
                    {75,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$75'
                }
            },
            {
                ['titem'] = 'Glass',
                ['titemreq'] = {
                    {35,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$35'
                }
            },
            {
                ['titem'] = 'Rubber',
                ['titemreq'] = {
                    {70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$70'
                }
            },
            {
                ['titem'] = 'Gunpowder',
                ['titemreq'] = {
                    {100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$100'
                }
            },
            {
                ['titem'] = 'Paper',
                ['titemreq'] = {
                    {5,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$5'
                }
            },
            {
                ['titem'] = 'Cloth',
                ['titemreq'] = {
                    {25,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$25'
                }
            },
            {
                ['titem'] = 'Pills',
                ['titemreq'] = {
                    {75,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$75'
                }
            },
            {
                ['titem'] = 'Relogioroubado',
                ['titemreq'] = {
                    {400,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$400'
                }
            },
            {
                ['titem'] = 'Pulseiraroubada',
                ['titemreq'] = {
                    {100,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$100'
                }
            },
            {
                ['titem'] = 'Anelroubado',
                ['titemreq'] = {
                    {70,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$70'
                }
            },
            {
                ['titem'] = 'Colarroubado',
                ['titemreq'] = {
                    {250,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$250'
                }
            },
            {
                ['titem'] = 'Brincoroubado',
                ['titemreq'] = {
                    {150,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$150'
                }
            },
            {
                ['titem'] = 'Carteiraroubada',
                ['titemreq'] = {
                    {250,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$250'
                }
            },
            {
                ['titem'] = 'Tabletroubado',
                ['titemreq'] = {
                    {200,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$200'
                }
            },
            {
                ['titem'] = 'Sapatosroubado',
                ['titemreq'] = {
                    {50,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$50'
                }
            },
            {
                ['titem'] = 'Can',
                ['titemreq'] = {
                    {3,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$3'
                }
            },
            {
                ['titem'] = 'Phone',
                ['titemreq'] = {
                    {1500,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$1500'
                }
            },
        }
    },
    [15] = {
        ['item'] = {
            {
                ['titem'] = 'Phone',
                ['titemreq'] = {
                    {2500,'Money'},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    {nil,nil},
                    ['titemreqtext'] = '$2500'
                }
            },
        }
    },
}




