function getsemimajoraxis(args::Int...)
    # call gm values
    sma_dict = getsemimajoraxis_dict()
    a_out = []
    for naifID in args
        bdyname = "BODY" * string(naifID) * "_semiMajorAxis"
        push!( a_out, sma_dict[bdyname] )
    end
    return Tuple(a_out)
end


# ------------------------------------------------------------------------- #
function getsemimajoraxis_dict()
    sma_dict = Dict(

        "BODY199_semiMajorAxis"     =>  57.91e6  ,
        "BODY299_semiMajorAxis"     => 108.21e6  ,
        "BODY399_semiMajorAxis"     => 149.60e6  ,
        "BODY499_semiMajorAxis"     => 227.92e6  ,
        "BODY599_semiMajorAxis"     => 778.57e6  ,
        "BODY699_semiMajorAxis"     => 1433.53e6 ,
        "BODY799_semiMajorAxis"     => 2872.46e6 ,
        "BODY899_semiMajorAxis"     => 4495.06e6 ,
        "BODY999_semiMajorAxis"     => 5906.38e6 ,

        "BODY301_semiMajorAxis"     => 0.3844e6 ,

        "BODY401_semiMajorAxis"     => 9378.0 ,
        "BODY402_semiMajorAxis"     => 23459.0 ,

        "BODY501_semiMajorAxis"     => 431.8e3 ,
        "BODY502_semiMajorAxis"     => 671.1e3 ,
        "BODY503_semiMajorAxis"     => 1070.4e3 ,
        "BODY504_semiMajorAxis"     => 1882.7e3 ,
        "BODY505_semiMajorAxis"     => 181.4e3 ,

        "BODY601_semiMajorAxis"     => 185.52e3 ,
        "BODY602_semiMajorAxis"     => 238.02e3 ,
        "BODY603_semiMajorAxis"     => 294.64e3 ,
        "BODY604_semiMajorAxis"     => 377.60e3 ,
        "BODY605_semiMajorAxis"     => 527.04e3 ,
        "BODY606_semiMajorAxis"     => 1221.83e3 ,
        "BODY607_semiMajorAxis"     => 1481.1e3 ,
        "BODY608_semiMajorAxis"     => 3561.3e3 ,
        "BODY609_semiMajorAxis"     => 5.531110414633374E-01 ,
        "BODY610_semiMajorAxis"     => 1.266231296945636E-01 ,
        "BODY611_semiMajorAxis"     => 3.513977490568457E-02 ,
        "BODY615_semiMajorAxis"     => 3.759718886965353E-04 ,
        "BODY616_semiMajorAxis"     => 1.066368426666134E-02 ,
        "BODY617_semiMajorAxis"     => 9.103768311054300E-03 ,

        "BODY701_semiMajorAxis"     => 190.90e3 ,
        "BODY702_semiMajorAxis"     => 266.00e3 ,
        "BODY703_semiMajorAxis"     => 436.39e3 ,
        "BODY704_semiMajorAxis"     => 583.50e3 ,
        "BODY705_semiMajorAxis"     => 129.90e3 ,

        "BODY801_semiMajorAxis"     => 354.76e3,

        "BODY901_semiMajorAxis"     => 19596 ,
        "BODY902_semiMajorAxis"     => 48690 ,
        "BODY903_semiMajorAxis"     => 64740 ,
        "BODY904_semiMajorAxis"     => 57780,
    )
    return sma_dict
end