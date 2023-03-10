PGDMP     '    *                z         
   Restaurant    14.5    14.5 n    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    16861 
   Restaurant    DATABASE     i   CREATE DATABASE "Restaurant" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Turkish_Turkey.1254';
    DROP DATABASE "Restaurant";
                postgres    false            ?            1255    17657 
   avgprice()    FUNCTION     ?   CREATE FUNCTION public.avgprice() RETURNS TABLE(number double precision)
    LANGUAGE plpgsql
    AS $$ -- Begining of function body
BEGIN
    RETURN QUERY SELECT AVG("totalprice") FROM "order";
END;
$$;
 !   DROP FUNCTION public.avgprice();
       public          postgres    false            ?            1255    17429    beveragelistpricechanges()    FUNCTION     ?  CREATE FUNCTION public.beveragelistpricechanges() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."beverageprice" <> OLD."beverageprice" THEN
        INSERT INTO "beveragelistpricechanges"("beverageid", "oldbeverageprice", "newbeverageprice", "updatedate")
        VALUES(OLD."beverageid", OLD."beverageprice" , NEW."beverageprice", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$;
 1   DROP FUNCTION public.beveragelistpricechanges();
       public          postgres    false            ?            1255    17441    calctax(real)    FUNCTION     ?   CREATE FUNCTION public.calctax(normalprice real, OUT taxprice real) RETURNS real
    LANGUAGE plpgsql
    AS $$
BEGIN
    taxPrice := 0.18* normalPrice;
END;
$$;
 C   DROP FUNCTION public.calctax(normalprice real, OUT taxprice real);
       public          postgres    false            ?            1255    17476    deletedOrdersFunc()    FUNCTION     C  CREATE FUNCTION public."deletedOrdersFunc"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    INSERT INTO "deletedOrders"("orderId", "staffId", "tableId", "orderAddress", "deletedDate")
    VALUES(OLD."orderid", OLD."staffid", OLD."tableid", OLD."orderaddress", CURRENT_TIMESTAMP::TIMESTAMP);
RETURN OLD;
END;
$$;
 ,   DROP FUNCTION public."deletedOrdersFunc"();
       public          postgres    false            ?            1255    17414    foodlistpricechanges()    FUNCTION     z  CREATE FUNCTION public.foodlistpricechanges() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."foodprice" <> OLD."foodprice" THEN
        INSERT INTO "foodlistpricechanges"("foodid", "oldfoodprice", "newfoodprice", "updatedate")
        VALUES(OLD."foodid", OLD."foodprice" , NEW."foodprice", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.foodlistpricechanges();
       public          postgres    false            ?            1255    17440    searchorder(integer)    FUNCTION     N  CREATE FUNCTION public.searchorder(ordernumber integer) RETURNS TABLE(orderno integer, staffno integer, tableno integer, addres character varying, price real)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "orderid","staffid", "tableid", "orderaddress", "totalprice" FROM "order" WHERE "orderid" = ordernumber;
END;
$$;
 7   DROP FUNCTION public.searchorder(ordernumber integer);
       public          postgres    false            ?            1255    17652    totalprice()    FUNCTION     ?   CREATE FUNCTION public.totalprice() RETURNS TABLE(number real)
    LANGUAGE plpgsql
    AS $$ -- Begining of function body
BEGIN
    RETURN QUERY SELECT SUM("totalprice") FROM "order";
END;
$$;
 #   DROP FUNCTION public.totalprice();
       public          postgres    false            ?            1255    17662    trimAddress()    FUNCTION     ?   CREATE FUNCTION public."trimAddress"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."orderaddress" = LTRIM(NEW."orderaddress"); -- Clear previous and next spaces
    RETURN NEW;
END;
$$;
 &   DROP FUNCTION public."trimAddress"();
       public          postgres    false            ?            1259    17222    beveragelist    TABLE     ?   CREATE TABLE public.beveragelist (
    beverageid integer NOT NULL,
    beveragename character varying NOT NULL,
    beverageprice real NOT NULL
);
     DROP TABLE public.beveragelist;
       public         heap    postgres    false            ?            1259    17221    beveragelist_beverageid_seq    SEQUENCE     ?   CREATE SEQUENCE public.beveragelist_beverageid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.beveragelist_beverageid_seq;
       public          postgres    false    226            ?           0    0    beveragelist_beverageid_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.beveragelist_beverageid_seq OWNED BY public.beveragelist.beverageid;
          public          postgres    false    225            ?            1259    17423    beveragelistpricechanges    TABLE     ?   CREATE TABLE public.beveragelistpricechanges (
    beveragelistrecordno integer NOT NULL,
    beverageid smallint NOT NULL,
    oldbeverageprice real NOT NULL,
    newbeverageprice real NOT NULL,
    updatedate timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.beveragelistpricechanges;
       public         heap    postgres    false            ?            1259    17422 1   beveragelistpricechanges_beveragelistrecordno_seq    SEQUENCE     ?   CREATE SEQUENCE public.beveragelistpricechanges_beveragelistrecordno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 H   DROP SEQUENCE public.beveragelistpricechanges_beveragelistrecordno_seq;
       public          postgres    false    230            ?           0    0 1   beveragelistpricechanges_beveragelistrecordno_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.beveragelistpricechanges_beveragelistrecordno_seq OWNED BY public.beveragelistpricechanges.beveragelistrecordno;
          public          postgres    false    229            ?            1259    17130 	   beverages    TABLE     ?   CREATE TABLE public.beverages (
    beverageid integer NOT NULL,
    beveragename character varying(100) NOT NULL,
    beverageprice real NOT NULL,
    orderid integer NOT NULL
);
    DROP TABLE public.beverages;
       public         heap    postgres    false            ?            1259    17129    beverages_beverageid_seq    SEQUENCE     ?   CREATE SEQUENCE public.beverages_beverageid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.beverages_beverageid_seq;
       public          postgres    false    222            ?           0    0    beverages_beverageid_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.beverages_beverageid_seq OWNED BY public.beverages.beverageid;
          public          postgres    false    221            ?            1259    16985    cashier    TABLE     >   CREATE TABLE public.cashier (
    staffid integer NOT NULL
);
    DROP TABLE public.cashier;
       public         heap    postgres    false            ?            1259    17102    checkout    TABLE     m   CREATE TABLE public.checkout (
    sectionid integer NOT NULL,
    cashierid integer,
    orderid integer
);
    DROP TABLE public.checkout;
       public         heap    postgres    false            ?            1259    17005    courier    TABLE     >   CREATE TABLE public.courier (
    staffid integer NOT NULL
);
    DROP TABLE public.courier;
       public         heap    postgres    false            ?            1259    17456    deletedOrders    TABLE       CREATE TABLE public."deletedOrders" (
    "deletedOrdersId" integer NOT NULL,
    "orderId" integer NOT NULL,
    "staffId" integer NOT NULL,
    "tableId" integer NOT NULL,
    "orderAddress" character varying,
    "deletedDate" timestamp without time zone NOT NULL
);
 #   DROP TABLE public."deletedOrders";
       public         heap    postgres    false            ?            1259    17455 !   deletedOrders_deletedOrdersId_seq    SEQUENCE     ?   CREATE SEQUENCE public."deletedOrders_deletedOrdersId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public."deletedOrders_deletedOrdersId_seq";
       public          postgres    false    232            ?           0    0 !   deletedOrders_deletedOrdersId_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."deletedOrders_deletedOrdersId_seq" OWNED BY public."deletedOrders"."deletedOrdersId";
          public          postgres    false    231            ?            1259    17215    foodlist    TABLE     ?   CREATE TABLE public.foodlist (
    foodid integer NOT NULL,
    foodname character varying(100) NOT NULL,
    foodprice real NOT NULL
);
    DROP TABLE public.foodlist;
       public         heap    postgres    false            ?            1259    17214    foodlist_foodid_seq    SEQUENCE     ?   CREATE SEQUENCE public.foodlist_foodid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.foodlist_foodid_seq;
       public          postgres    false    224            ?           0    0    foodlist_foodid_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.foodlist_foodid_seq OWNED BY public.foodlist.foodid;
          public          postgres    false    223            ?            1259    17408    foodlistpricechanges    TABLE     ?   CREATE TABLE public.foodlistpricechanges (
    foodlistrecordno integer NOT NULL,
    foodid smallint NOT NULL,
    oldfoodprice real NOT NULL,
    newfoodprice real NOT NULL,
    updatedate timestamp without time zone NOT NULL
);
 (   DROP TABLE public.foodlistpricechanges;
       public         heap    postgres    false            ?            1259    17407 )   foodlistpricechanges_foodlistrecordno_seq    SEQUENCE     ?   CREATE SEQUENCE public.foodlistpricechanges_foodlistrecordno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public.foodlistpricechanges_foodlistrecordno_seq;
       public          postgres    false    228            ?           0    0 )   foodlistpricechanges_foodlistrecordno_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public.foodlistpricechanges_foodlistrecordno_seq OWNED BY public.foodlistpricechanges.foodlistrecordno;
          public          postgres    false    227            ?            1259    17123    foods    TABLE     ?   CREATE TABLE public.foods (
    foodid integer NOT NULL,
    foodname character varying(100) NOT NULL,
    foodprice real NOT NULL,
    orderid integer NOT NULL
);
    DROP TABLE public.foods;
       public         heap    postgres    false            ?            1259    17122    foods_foodid_seq    SEQUENCE     ?   CREATE SEQUENCE public.foods_foodid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.foods_foodid_seq;
       public          postgres    false    220            ?           0    0    foods_foodid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.foods_foodid_seq OWNED BY public.foods.foodid;
          public          postgres    false    219            ?            1259    17027    kitchen    TABLE     U   CREATE TABLE public.kitchen (
    sectionid integer NOT NULL,
    orderid integer
);
    DROP TABLE public.kitchen;
       public         heap    postgres    false            ?            1259    17016    order    TABLE     ?   CREATE TABLE public."order" (
    orderid integer NOT NULL,
    orderaddress character varying(300),
    totalprice real,
    staffid integer,
    tableid integer NOT NULL
);
    DROP TABLE public."order";
       public         heap    postgres    false            ?            1259    17015    order_orderid_seq    SEQUENCE     ?   CREATE SEQUENCE public.order_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.order_orderid_seq;
       public          postgres    false    215            ?           0    0    order_orderid_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.order_orderid_seq OWNED BY public."order".orderid;
          public          postgres    false    214            ?            1259    16957    staff    TABLE     ?   CREATE TABLE public.staff (
    staffid integer NOT NULL,
    stafftype character varying(50) NOT NULL,
    staffname character varying,
    staffphoneno character(11)
);
    DROP TABLE public.staff;
       public         heap    postgres    false            ?            1259    16956    staff_staffid_seq    SEQUENCE     ?   CREATE SEQUENCE public.staff_staffid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.staff_staffid_seq;
       public          postgres    false    210            ?           0    0    staff_staffid_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.staff_staffid_seq OWNED BY public.staff.staffid;
          public          postgres    false    209            ?            1259    17062    tables    TABLE     =   CREATE TABLE public.tables (
    tableid integer NOT NULL
);
    DROP TABLE public.tables;
       public         heap    postgres    false            ?            1259    16995    waiter    TABLE     =   CREATE TABLE public.waiter (
    staffid integer NOT NULL
);
    DROP TABLE public.waiter;
       public         heap    postgres    false            ?           2604    17225    beveragelist beverageid    DEFAULT     ?   ALTER TABLE ONLY public.beveragelist ALTER COLUMN beverageid SET DEFAULT nextval('public.beveragelist_beverageid_seq'::regclass);
 F   ALTER TABLE public.beveragelist ALTER COLUMN beverageid DROP DEFAULT;
       public          postgres    false    225    226    226            ?           2604    17426 -   beveragelistpricechanges beveragelistrecordno    DEFAULT     ?   ALTER TABLE ONLY public.beveragelistpricechanges ALTER COLUMN beveragelistrecordno SET DEFAULT nextval('public.beveragelistpricechanges_beveragelistrecordno_seq'::regclass);
 \   ALTER TABLE public.beveragelistpricechanges ALTER COLUMN beveragelistrecordno DROP DEFAULT;
       public          postgres    false    230    229    230            ?           2604    17133    beverages beverageid    DEFAULT     |   ALTER TABLE ONLY public.beverages ALTER COLUMN beverageid SET DEFAULT nextval('public.beverages_beverageid_seq'::regclass);
 C   ALTER TABLE public.beverages ALTER COLUMN beverageid DROP DEFAULT;
       public          postgres    false    221    222    222            ?           2604    17459    deletedOrders deletedOrdersId    DEFAULT     ?   ALTER TABLE ONLY public."deletedOrders" ALTER COLUMN "deletedOrdersId" SET DEFAULT nextval('public."deletedOrders_deletedOrdersId_seq"'::regclass);
 P   ALTER TABLE public."deletedOrders" ALTER COLUMN "deletedOrdersId" DROP DEFAULT;
       public          postgres    false    231    232    232            ?           2604    17218    foodlist foodid    DEFAULT     r   ALTER TABLE ONLY public.foodlist ALTER COLUMN foodid SET DEFAULT nextval('public.foodlist_foodid_seq'::regclass);
 >   ALTER TABLE public.foodlist ALTER COLUMN foodid DROP DEFAULT;
       public          postgres    false    223    224    224            ?           2604    17411 %   foodlistpricechanges foodlistrecordno    DEFAULT     ?   ALTER TABLE ONLY public.foodlistpricechanges ALTER COLUMN foodlistrecordno SET DEFAULT nextval('public.foodlistpricechanges_foodlistrecordno_seq'::regclass);
 T   ALTER TABLE public.foodlistpricechanges ALTER COLUMN foodlistrecordno DROP DEFAULT;
       public          postgres    false    227    228    228            ?           2604    17126    foods foodid    DEFAULT     l   ALTER TABLE ONLY public.foods ALTER COLUMN foodid SET DEFAULT nextval('public.foods_foodid_seq'::regclass);
 ;   ALTER TABLE public.foods ALTER COLUMN foodid DROP DEFAULT;
       public          postgres    false    220    219    220            ?           2604    17019    order orderid    DEFAULT     p   ALTER TABLE ONLY public."order" ALTER COLUMN orderid SET DEFAULT nextval('public.order_orderid_seq'::regclass);
 >   ALTER TABLE public."order" ALTER COLUMN orderid DROP DEFAULT;
       public          postgres    false    214    215    215            ?           2604    16960    staff staffid    DEFAULT     n   ALTER TABLE ONLY public.staff ALTER COLUMN staffid SET DEFAULT nextval('public.staff_staffid_seq'::regclass);
 <   ALTER TABLE public.staff ALTER COLUMN staffid DROP DEFAULT;
       public          postgres    false    210    209    210            {          0    17222    beveragelist 
   TABLE DATA           O   COPY public.beveragelist (beverageid, beveragename, beverageprice) FROM stdin;
    public          postgres    false    226   ??                 0    17423    beveragelistpricechanges 
   TABLE DATA           ?   COPY public.beveragelistpricechanges (beveragelistrecordno, beverageid, oldbeverageprice, newbeverageprice, updatedate) FROM stdin;
    public          postgres    false    230   ??       w          0    17130 	   beverages 
   TABLE DATA           U   COPY public.beverages (beverageid, beveragename, beverageprice, orderid) FROM stdin;
    public          postgres    false    222   9?       l          0    16985    cashier 
   TABLE DATA           *   COPY public.cashier (staffid) FROM stdin;
    public          postgres    false    211   ??       s          0    17102    checkout 
   TABLE DATA           A   COPY public.checkout (sectionid, cashierid, orderid) FROM stdin;
    public          postgres    false    218   ˆ       n          0    17005    courier 
   TABLE DATA           *   COPY public.courier (staffid) FROM stdin;
    public          postgres    false    213   ??       ?          0    17456    deletedOrders 
   TABLE DATA           |   COPY public."deletedOrders" ("deletedOrdersId", "orderId", "staffId", "tableId", "orderAddress", "deletedDate") FROM stdin;
    public          postgres    false    232   	?       y          0    17215    foodlist 
   TABLE DATA           ?   COPY public.foodlist (foodid, foodname, foodprice) FROM stdin;
    public          postgres    false    224   Ƈ       }          0    17408    foodlistpricechanges 
   TABLE DATA           p   COPY public.foodlistpricechanges (foodlistrecordno, foodid, oldfoodprice, newfoodprice, updatedate) FROM stdin;
    public          postgres    false    228   8?       u          0    17123    foods 
   TABLE DATA           E   COPY public.foods (foodid, foodname, foodprice, orderid) FROM stdin;
    public          postgres    false    220   ??       q          0    17027    kitchen 
   TABLE DATA           5   COPY public.kitchen (sectionid, orderid) FROM stdin;
    public          postgres    false    216   ?       p          0    17016    order 
   TABLE DATA           V   COPY public."order" (orderid, orderaddress, totalprice, staffid, tableid) FROM stdin;
    public          postgres    false    215   :?       k          0    16957    staff 
   TABLE DATA           L   COPY public.staff (staffid, stafftype, staffname, staffphoneno) FROM stdin;
    public          postgres    false    210   ??       r          0    17062    tables 
   TABLE DATA           )   COPY public.tables (tableid) FROM stdin;
    public          postgres    false    217   H?       m          0    16995    waiter 
   TABLE DATA           )   COPY public.waiter (staffid) FROM stdin;
    public          postgres    false    212   w?       ?           0    0    beveragelist_beverageid_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.beveragelist_beverageid_seq', 7, true);
          public          postgres    false    225            ?           0    0 1   beveragelistpricechanges_beveragelistrecordno_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('public.beveragelistpricechanges_beveragelistrecordno_seq', 1, true);
          public          postgres    false    229            ?           0    0    beverages_beverageid_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.beverages_beverageid_seq', 108, true);
          public          postgres    false    221            ?           0    0 !   deletedOrders_deletedOrdersId_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."deletedOrders_deletedOrdersId_seq"', 9, true);
          public          postgres    false    231            ?           0    0    foodlist_foodid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.foodlist_foodid_seq', 8, true);
          public          postgres    false    223            ?           0    0 )   foodlistpricechanges_foodlistrecordno_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.foodlistpricechanges_foodlistrecordno_seq', 5, true);
          public          postgres    false    227            ?           0    0    foods_foodid_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.foods_foodid_seq', 104, true);
          public          postgres    false    219            ?           0    0    order_orderid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.order_orderid_seq', 121, true);
          public          postgres    false    214            ?           0    0    staff_staffid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.staff_staffid_seq', 8, true);
          public          postgres    false    209            ?           2606    17413    foodlistpricechanges PK 
   CONSTRAINT     e   ALTER TABLE ONLY public.foodlistpricechanges
    ADD CONSTRAINT "PK" PRIMARY KEY (foodlistrecordno);
 C   ALTER TABLE ONLY public.foodlistpricechanges DROP CONSTRAINT "PK";
       public            postgres    false    228            ?           2606    17392    beveragelist beveragelistpk 
   CONSTRAINT     a   ALTER TABLE ONLY public.beveragelist
    ADD CONSTRAINT beveragelistpk PRIMARY KEY (beverageid);
 E   ALTER TABLE ONLY public.beveragelist DROP CONSTRAINT beveragelistpk;
       public            postgres    false    226            ?           2606    17428 3   beveragelistpricechanges beveragelistpricechangespk 
   CONSTRAINT     ?   ALTER TABLE ONLY public.beveragelistpricechanges
    ADD CONSTRAINT beveragelistpricechangespk PRIMARY KEY (beveragelistrecordno);
 ]   ALTER TABLE ONLY public.beveragelistpricechanges DROP CONSTRAINT beveragelistpricechangespk;
       public            postgres    false    230            ?           2606    17135    beverages beveragespk 
   CONSTRAINT     [   ALTER TABLE ONLY public.beverages
    ADD CONSTRAINT beveragespk PRIMARY KEY (beverageid);
 ?   ALTER TABLE ONLY public.beverages DROP CONSTRAINT beveragespk;
       public            postgres    false    222            ?           2606    16989    cashier cashierpk 
   CONSTRAINT     T   ALTER TABLE ONLY public.cashier
    ADD CONSTRAINT cashierpk PRIMARY KEY (staffid);
 ;   ALTER TABLE ONLY public.cashier DROP CONSTRAINT cashierpk;
       public            postgres    false    211            ?           2606    17106    checkout checkoutpk 
   CONSTRAINT     X   ALTER TABLE ONLY public.checkout
    ADD CONSTRAINT checkoutpk PRIMARY KEY (sectionid);
 =   ALTER TABLE ONLY public.checkout DROP CONSTRAINT checkoutpk;
       public            postgres    false    218            ?           2606    17009    courier courierpk 
   CONSTRAINT     T   ALTER TABLE ONLY public.courier
    ADD CONSTRAINT courierpk PRIMARY KEY (staffid);
 ;   ALTER TABLE ONLY public.courier DROP CONSTRAINT courierpk;
       public            postgres    false    213            ?           2606    17463    deletedOrders deletedOrdersPk 
   CONSTRAINT     n   ALTER TABLE ONLY public."deletedOrders"
    ADD CONSTRAINT "deletedOrdersPk" PRIMARY KEY ("deletedOrdersId");
 K   ALTER TABLE ONLY public."deletedOrders" DROP CONSTRAINT "deletedOrdersPk";
       public            postgres    false    232            ?           2606    17390    foodlist foodlistpk 
   CONSTRAINT     U   ALTER TABLE ONLY public.foodlist
    ADD CONSTRAINT foodlistpk PRIMARY KEY (foodid);
 =   ALTER TABLE ONLY public.foodlist DROP CONSTRAINT foodlistpk;
       public            postgres    false    224            ?           2606    17128    foods foodspk 
   CONSTRAINT     O   ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foodspk PRIMARY KEY (foodid);
 7   ALTER TABLE ONLY public.foods DROP CONSTRAINT foodspk;
       public            postgres    false    220            ?           2606    17031    kitchen kitchenpk 
   CONSTRAINT     V   ALTER TABLE ONLY public.kitchen
    ADD CONSTRAINT kitchenpk PRIMARY KEY (sectionid);
 ;   ALTER TABLE ONLY public.kitchen DROP CONSTRAINT kitchenpk;
       public            postgres    false    216            ?           2606    17021    order orderpk 
   CONSTRAINT     R   ALTER TABLE ONLY public."order"
    ADD CONSTRAINT orderpk PRIMARY KEY (orderid);
 9   ALTER TABLE ONLY public."order" DROP CONSTRAINT orderpk;
       public            postgres    false    215            ?           2606    16962    staff staffpk 
   CONSTRAINT     P   ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staffpk PRIMARY KEY (staffid);
 7   ALTER TABLE ONLY public.staff DROP CONSTRAINT staffpk;
       public            postgres    false    210            ?           2606    17383    tables tablespk 
   CONSTRAINT     R   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tablespk PRIMARY KEY (tableid);
 9   ALTER TABLE ONLY public.tables DROP CONSTRAINT tablespk;
       public            postgres    false    217            ?           2606    17229 +   beveragelist unique_beveragelist_beverageid 
   CONSTRAINT     l   ALTER TABLE ONLY public.beveragelist
    ADD CONSTRAINT unique_beveragelist_beverageid UNIQUE (beverageid);
 U   ALTER TABLE ONLY public.beveragelist DROP CONSTRAINT unique_beveragelist_beverageid;
       public            postgres    false    226            ?           2606    17220    foodlist unique_foodlist_foodid 
   CONSTRAINT     \   ALTER TABLE ONLY public.foodlist
    ADD CONSTRAINT unique_foodlist_foodid UNIQUE (foodid);
 I   ALTER TABLE ONLY public.foodlist DROP CONSTRAINT unique_foodlist_foodid;
       public            postgres    false    224            ?           2606    17381    tables unique_tables_tableid 
   CONSTRAINT     Z   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT unique_tables_tableid UNIQUE (tableid);
 F   ALTER TABLE ONLY public.tables DROP CONSTRAINT unique_tables_tableid;
       public            postgres    false    217            ?           2606    16999    waiter waiterpk 
   CONSTRAINT     R   ALTER TABLE ONLY public.waiter
    ADD CONSTRAINT waiterpk PRIMARY KEY (staffid);
 9   ALTER TABLE ONLY public.waiter DROP CONSTRAINT waiterpk;
       public            postgres    false    212            ?           2620    17430 ,   beveragelist beveragelistpricechangestrigger    TRIGGER     ?   CREATE TRIGGER beveragelistpricechangestrigger BEFORE UPDATE ON public.beveragelist FOR EACH ROW EXECUTE FUNCTION public.beveragelistpricechanges();
 E   DROP TRIGGER beveragelistpricechangestrigger ON public.beveragelist;
       public          postgres    false    234    226            ?           2620    17477    order deletedOrdersTrigger    TRIGGER     ?   CREATE TRIGGER "deletedOrdersTrigger" BEFORE DELETE ON public."order" FOR EACH ROW EXECUTE FUNCTION public."deletedOrdersFunc"();
 7   DROP TRIGGER "deletedOrdersTrigger" ON public."order";
       public          postgres    false    237    215            ?           2620    17416 $   foodlist foodlistpricechangestrigger    TRIGGER     ?   CREATE TRIGGER foodlistpricechangestrigger BEFORE UPDATE ON public.foodlist FOR EACH ROW EXECUTE FUNCTION public.foodlistpricechanges();
 =   DROP TRIGGER foodlistpricechangestrigger ON public.foodlist;
       public          postgres    false    233    224            ?           2620    17663    order trimSpaceTrigger    TRIGGER     x   CREATE TRIGGER "trimSpaceTrigger" BEFORE INSERT ON public."order" FOR EACH ROW EXECUTE FUNCTION public."trimAddress"();
 3   DROP TRIGGER "trimSpaceTrigger" ON public."order";
       public          postgres    false    215    240            ?           2606    17364    beverages beveragesfk    FK CONSTRAINT     ?   ALTER TABLE ONLY public.beverages
    ADD CONSTRAINT beveragesfk FOREIGN KEY (orderid) REFERENCES public."order"(orderid) ON UPDATE CASCADE ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.beverages DROP CONSTRAINT beveragesfk;
       public          postgres    false    222    215    3254            ?           2606    17273    cashier cashierfk    FK CONSTRAINT     ?   ALTER TABLE ONLY public.cashier
    ADD CONSTRAINT cashierfk FOREIGN KEY (staffid) REFERENCES public.staff(staffid) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY public.cashier DROP CONSTRAINT cashierfk;
       public          postgres    false    210    3246    211            ?           2606    17112    checkout checkoutfk2    FK CONSTRAINT     |   ALTER TABLE ONLY public.checkout
    ADD CONSTRAINT checkoutfk2 FOREIGN KEY (cashierid) REFERENCES public.cashier(staffid);
 >   ALTER TABLE ONLY public.checkout DROP CONSTRAINT checkoutfk2;
       public          postgres    false    3248    211    218            ?           2606    17117    checkout checkoutfk3    FK CONSTRAINT     z   ALTER TABLE ONLY public.checkout
    ADD CONSTRAINT checkoutfk3 FOREIGN KEY (orderid) REFERENCES public."order"(orderid);
 >   ALTER TABLE ONLY public.checkout DROP CONSTRAINT checkoutfk3;
       public          postgres    false    3254    218    215            ?           2606    17283    courier courierfk    FK CONSTRAINT     ?   ALTER TABLE ONLY public.courier
    ADD CONSTRAINT courierfk FOREIGN KEY (staffid) REFERENCES public.staff(staffid) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY public.courier DROP CONSTRAINT courierfk;
       public          postgres    false    210    3246    213            ?           2606    17359    foods foodsdk    FK CONSTRAINT     ?   ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foodsdk FOREIGN KEY (orderid) REFERENCES public."order"(orderid) ON UPDATE CASCADE ON DELETE CASCADE;
 7   ALTER TABLE ONLY public.foods DROP CONSTRAINT foodsdk;
       public          postgres    false    3254    220    215            ?           2606    17037    kitchen kitchenfk2    FK CONSTRAINT     x   ALTER TABLE ONLY public.kitchen
    ADD CONSTRAINT kitchenfk2 FOREIGN KEY (orderid) REFERENCES public."order"(orderid);
 <   ALTER TABLE ONLY public.kitchen DROP CONSTRAINT kitchenfk2;
       public          postgres    false    3254    215    216            ?           2606    17022    order orderfk    FK CONSTRAINT     s   ALTER TABLE ONLY public."order"
    ADD CONSTRAINT orderfk FOREIGN KEY (staffid) REFERENCES public.staff(staffid);
 9   ALTER TABLE ONLY public."order" DROP CONSTRAINT orderfk;
       public          postgres    false    215    210    3246            ?           2606    17384    order tablefk    FK CONSTRAINT     ?   ALTER TABLE ONLY public."order"
    ADD CONSTRAINT tablefk FOREIGN KEY (tableid) REFERENCES public.tables(tableid) ON UPDATE CASCADE ON DELETE CASCADE;
 9   ALTER TABLE ONLY public."order" DROP CONSTRAINT tablefk;
       public          postgres    false    217    3260    215            ?           2606    17278    waiter waiterfk    FK CONSTRAINT     ?   ALTER TABLE ONLY public.waiter
    ADD CONSTRAINT waiterfk FOREIGN KEY (staffid) REFERENCES public.staff(staffid) ON UPDATE CASCADE ON DELETE CASCADE;
 9   ALTER TABLE ONLY public.waiter DROP CONSTRAINT waiterfk;
       public          postgres    false    210    3246    212            {   `   x?˽@0?????p??b7I?$K?א??????y?uP??8X???3?ג??{???$??U?????N-????B+{<?,S?/Ċ?         1   x???  ?w???h?????0!x??&5????ۣ?R???>?      w   a   x?]?=
?0???)<AI?V3;?	.."J???[7q}<?
?E?	$0??x??fi??9K?~?ҹ?d?mF!e???s)?}??P24??????????U      l      x?3?2?????? ?$      s      x?????? ? ?      n      x?3???????? ?(      ?   ?   x???;? ??>E.?_`8DO?%R?*C???4??>????ϖ(;0,??<??yg?b??)*TȰn?L????q?K????v-IU,+Z
%?3??Ւ8??%({??'?FY?F?-þm{???~]??,1??C?X?~걒?sM?H?b?a????N???????˸F>      y   b   x??1
?@?????ͨ??]??f?!;????X>^@??/?`??vH?~???=#F?3a???o?˙??p@??v??>??u?cy???V?      }   f   x?m???@?3D????4t,??GK?????dJP?6ܰ?r+6Lj֔1?9"?&K????(?????ވ?!D5!????d&Ӌ???ϓ??????0??6 ?      u   _   x?]ͻ?0E??yd??@Z?"? ???K????ꂭ??RE?帡?:?0?!8???j??A???:6\FJ?i?????"ڀ=?}s?#N      q      x?????? ? ?      p   k   x?340????47?4?4?244?<???$1/?4G'???????TNcNcN??H?????)?k?Z?By?`IK=SN3NC.C#8??7?M ??`?L??Zc???? [(W      k   ?   x?3?LN,??L-?t???4056"?2?,O?,IT??
?2B0?e̙?_Z??
?ejjdldbjf?e7/2?????????F?\?0#O??@#???A?̹,?F:?%f????? ]???? ?p-?      r      x?3?2?2?2?2?2?2???2?????? "??      m      x?3?2?????? ?&     