﻿using System;
using System.Collections.Generic;

namespace DbmsHw.Entities;

public partial class Food
{
    public int Foodid { get; set; }

    public string Foodname { get; set; } = null!;

    public float Foodprice { get; set; }

    public int Orderid { get; set; }

    public virtual Order Order { get; set; } = null!;
}
