package Project2.simulations;


import inet.applications.httptools.configurator.HttpController;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.applications.contract.ITCPApp;
import inet.applications.httptools.browser.HttpBrowser;

@license(LGPL);

//
// This file is part of an OMNeT++/OMNEST simulation example.
//
// Copyright (C) 2003 Ahmet Sekercioglu
// Copyright (C) 2003-2015 Andras Varga
//
// This file is distributed WITHOUT ANY WARRANTY. See the file
// `license' for details on this and other legal matters.
//

channel ethernetline extends ned.DatarateChannel
{
    parameters:
        delay = 0.1us;
        datarate = 100Mbps;
}

//
//
// Clients and 1 server
//
//
network TwoTiered
{
    parameters:
        double numclients @prompt("Number of clients") = default(10);
        double numIoT @prompt("Number of IoT devices") = default(100); //effectively, the number of parking spaces per router
        @display("bgb=1000,600;bgl=4");
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                @display("p=50,50;i=block/cogwheel");
        }
        controller: HttpController {
            parameters:
                @display("p=62,156;i=block/cogwheel");
        }
        serverA: StandardHost {
            parameters:
                @display("p=365.205,163.15;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
                //@statistic[endToEndDelay](title="end-to-end delay"; source="messageAge(arrival)"; unit=s; record=histogram,vector; interpolationmode=none);
				//@statistic[dropRate](title="Drop rate"; source=count(drop)/count(arrival); record=last,vector?);        
        } //drop variable has to be defined.
        router_A: Router {
            parameters:
                @display("p=583.575,318.77;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        router_1: Router {
            parameters:
                @display("p=367.715,317.51498;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        router_2: Router {
            parameters:
                @display("p=165.65999,318.77;is=l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsA[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=706.565,503.25497");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsB[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=332.57498,494.46997");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsC[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=67.77,493.215");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        a_IoT[numIoT]: StandardHost {
            parameters:
                @display("p=591.105,493.215");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        b_IoT[numIoT]: StandardHost {
            parameters:
                @display("p=430.465,480.66498");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        c_IoT[numIoT]: StandardHost {
            parameters:
                @display("p=163.15,486.93997");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }

    connections allowunconnected:
        router_A.ethg++ <--> ethernetline <--> serverA.ethg++;
        router_1.ethg++ <--> ethernetline <--> serverA.ethg++;
        router_2.ethg++ <--> ethernetline <--> serverA.ethg++;
        for i=0..numclients-1 {
            clientsA[i].ethg++ <--> ethernetline <--> router_A.ethg++;
        }
        for i=0..numclients-1 {
            clientsB[i].ethg++ <--> ethernetline <--> router_1.ethg++;
        }
        for i=0..numclients-1 {
            clientsC[i].ethg++ <--> ethernetline <--> router_2.ethg++;
        }

        for i=0..numIoT-1 {
            a_IoT[i].ethg++ <--> ethernetline <--> router_A.ethg++;
        }
        for i=0..numIoT-1 {
            b_IoT[i].ethg++ <--> ethernetline <--> router_1.ethg++;
        }
        for i=0..numIoT-1 {
            c_IoT[i].ethg++ <--> ethernetline <--> router_2.ethg++;
        }
        //for i=0..numIoT-1 {
        	//if (i < numIoT/3 - 1) {
        	//	IoT[i].ethg++ <--> ethernetline <--> router_0.ethg++;
        	//} else if (i < numIoT/3*2-1) {
        	//	IoT[i].ethg++ <--> ethernetline <--> router_1.ethg++;
        	//} else {
        	//	IoT[i].ethg++ <--> ethernetline <--> router_2.ethg++;
        	//}
        //}
}


//
//
// Clients and multiple servers at 3 layers
//
//
network MultiTiered
{
    parameters:
        double numclients @prompt("Number of clients") = default(10);
        double numIoT @prompt("Number of IoT devices") = default(1000); //effectively, the number of parking spaces per each lowest tier server
        @display("bgb=1000,600;bgl=4");
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                //                moduleTypes = "Router StandardHost";
                //                nonIPModuleTypes = "";
                @display("p=58,79;i=block/cogwheel");
        }
        //controller: HttpController {
        //    parameters:
        //        @display("p=62,156;i=block/cogwheel");
        //}
        router_2: Router {
            parameters:
                @display("p=474.38998,185.73999;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        router_1: Router {
            parameters:
                @display("p=297.435,189.50499;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB: StandardHost {
            parameters:
                @display("p=204.56499,189.50499;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverC: StandardHost {
            parameters:
                @display("p=586.08496,180.72;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverA: StandardHost {
            parameters:
                @display("p=449.28998,79.064995;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        router_0: Router {
            @display("p=367.715,81.575;is=l");
            @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsA[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=180.72,360.185");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        a_IoT[numIoT]: StandardHost {
            parameters:
                @display("p=297.435,348.88998");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        b_IoT[numIoT]: StandardHost {
            parameters:
                @display("p=494.46997,333.83");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsB[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=599.88995,342.615");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
    connections allowunconnected:
        serverB.ethg++ <--> ethernetline <--> router_1.ethg++;
        serverC.ethg++ <--> ethernetline <--> router_2.ethg++;
        router_0.ethg++ <--> ethernetline <--> router_2.ethg++;
        serverA.ethg++ <--> ethernetline <--> router_0.ethg++;
        router_0.ethg++ <--> ethernetline <--> router_1.ethg++;
        serverC.ethg++ <--> ethernetline <--> router_2.ethg++;
        a_IoT[0].ethg++ <--> router_1.ethg++;
        clientsA[0].ethg++ <--> router_1.ethg++;
        b_IoT[0].ethg++ <--> router_2.ethg++;
        clientsB[0].ethg++ <--> router_2.ethg++;
}