package Project2.simulations;

import inet.applications.httptools.configurator.HttpController;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.applications.contract.ITCPApp;
import inet.applications.httptools.browser.HttpBrowser;

@license(LGPL);

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
        double numclients @prompt("Number of clients") = default(1);
        double numIoT @prompt("Number of IoT devices") = default(10); //effectively, the number of parking spaces per router
        @display("bgb=1000,600;bgl=4");
        //following line will show how many packets server receives
        @figure[rcvdPkText](type=indicatorText; pos=420,20; anchor=w; font=,20; textFormat="packets received: %g"; initialValue=0);
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
        routerB: Router {
            parameters:
                @display("p=367.715,317.51498;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerC: Router {
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
        iotA[numIoT]: StandardHost {
            parameters:
                @display("p=591.105,493.215");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotB[numIoT]: StandardHost {
            parameters:
                @display("p=430.465,480.66498");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotC[numIoT]: StandardHost {
            parameters:
                @display("p=163.15,486.93997");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }

    connections allowunconnected:
        for i=0..numclients-1 {
            clientsA[i].ethg++ <--> ethernetline <--> router_A.ethg++;
        }
        for i=0..numclients-1 {
            clientsB[i].ethg++ <--> ethernetline <--> routerB.ethg++;
        }
        for i=0..numclients-1 {
            clientsC[i].ethg++ <--> ethernetline <--> routerC.ethg++;
        }

        for i=0..numIoT-1 {
            iotA[i].ethg++ <--> ethernetline <--> router_A.ethg++;
        }
        router_A.ethg++ <--> ethernetline <--> serverA.ethg++;
        for i=0..numIoT-1 {
            iotB[i].ethg++ <--> ethernetline <--> routerB.ethg++;
        }
        routerB.ethg++ <--> ethernetline <--> serverA.ethg++;
        routerC.ethg++ <--> ethernetline <--> serverA.ethg++;
        for i=0..numIoT-1 {
            iotC[i].ethg++ <--> ethernetline <--> routerC.ethg++;
        }
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
        routerC: Router {
            parameters:
                @display("p=474.38998,185.73999;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerB: Router {
            parameters:
                @display("p=297.435,189.50499;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB1: StandardHost {
            parameters:
                @display("p=204.56499,189.50499;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB2: StandardHost {
            parameters:
                @display("p=586.08496,180.72;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverA: StandardHost {
            parameters:
                @display("p=449.28998,79.064995;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerA: Router {
            @display("p=367.715,81.575;is=l");
            @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsA[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=180.72,360.185");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotA[numIoT]: StandardHost {
            parameters:
                @display("p=297.435,348.88998");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotB[numIoT]: StandardHost {
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
        serverB1.ethg++ <--> ethernetline <--> routerB.ethg++;
        serverB2.ethg++ <--> ethernetline <--> routerC.ethg++;
        routerA.ethg++ <--> ethernetline <--> routerC.ethg++;
        serverA.ethg++ <--> ethernetline <--> routerA.ethg++;
        routerA.ethg++ <--> ethernetline <--> routerB.ethg++;
        serverB2.ethg++ <--> ethernetline <--> routerC.ethg++;
        iotA[0].ethg++ <--> routerB.ethg++;
        clientsA[0].ethg++ <--> routerB.ethg++;
        iotB[0].ethg++ <--> routerC.ethg++;
        clientsB[0].ethg++ <--> routerC.ethg++;
}
