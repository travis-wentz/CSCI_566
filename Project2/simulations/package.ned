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
        double numIoT @prompt("Number of IoT devices") = default(5); //effectively, the number of parking spaces per router
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
                @statistic[endToEndDelay](title="end-to-end delay"; source="messageAge(arrival)"; unit=s; record=count,mean,histogram,vector?; interpolationmode=none);
				//@statistic[dropRate](title="Drop rate"; source=count(drop)/count(arrival); record=last,vector?);        
        } //drop variable has to be defined.
        router_A: Router {
            parameters:
                @display("p=583.575,318.77;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerB: Router {
            parameters:
                @display("p=365.205,262.29498;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerC: Router {
            parameters:
                @display("p=224.64499,247.23499;is=l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsA[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=657.62,409.12997");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsB[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=325.04498,365.205");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clientsC[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=110.439995,351.4");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotA[numIoT]: StandardHost {
            parameters:
                @display("p=532.12,422.935");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotB[numIoT]: StandardHost {
            parameters:
                @display("p=439.25,351.4");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iotC[numIoT]: StandardHost {
            parameters:
                @display("p=212.095,396.58");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }

        routerOrigin: Router {
            parameters:
                @display("p=272.335,66.515;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverOrigin: StandardHost {
            parameters:
                @display("p=163.15,43.925;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
                @statistic[endToEndDelay](title="end-to-end delay"; source="messageAge(arrival)"; unit=s; record=count,mean,histogram,vector?; interpolationmode=none);
				//@statistic[dropRate](title="Drop rate"; source=count(drop)/count(arrival); record=last,vector?);        
        } //drop variable has to be defined.
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
        routerOrigin.ethg++ <--> ethernetline <--> serverOrigin.ethg++;
        serverA.ethg++ <--> ethernetline <--> routerOrigin.ethg++;
        routerOrigin.ethg++ <--> ethernetline <--> serverOrigin.ethg++;
}


//
//
// Clients and multiple servers at 3 layers
//
//
network MultiTiered
{
    parameters:
        double numclients @prompt("Number of clients") = default(1);
        double numIoT @prompt("Number of IoT devices") = default(1); //effectively, the number of parking spaces per each lowest tier server
        @display("bgb=1000,600;bgl=4");
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                //                moduleTypes = "Router StandardHost";
                //                nonIPModuleTypes = "";
                @display("p=58,79;i=block/cogwheel");
        }
        controller: HttpController {
            parameters:
                @display("p=62,156;i=block/cogwheel");
        }
        routerB1: Router {
            parameters:
                @display("p=335.085,189.50499;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerB0: Router {
            parameters:
                @display("p=224.64499,189.50499;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB0: StandardHost {
            parameters:
                @display("p=141.815,189.50499;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB1: StandardHost {
            parameters:
                @display("p=416.65997,224.64499;i=device/server_l");
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
        clients0[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=91.615,351.4");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iot0[numIoT]: StandardHost {
            parameters:
                @display("p=194.525,342.615");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iot1[numIoT]: StandardHost {
            parameters:
                @display("p=322.535,351.4");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clients1[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=407.875,360.185");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerB2: Router {
            parameters:
                @display("p=524.58997,189.50499;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB2: StandardHost {
            parameters:
                @display("p=613.695,189.50499;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        clients2[numclients]: StandardHost {
            parameters:
                @display("i=device/laptop_l;p=622.48,360.185");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        iot2[numIoT]: StandardHost {
            parameters:
                @display("p=537.13995,351.4");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
    connections allowunconnected:
        for i=0..numclients-1 {
            clients0[i].ethg++ <--> ethernetline <--> routerB0.ethg++;
        }
        for i=0..numclients-1 {
            clients1[i].ethg++ <--> ethernetline <--> routerB1.ethg++;
        }
        for i=0..numclients-1 {
            clients2[i].ethg++ <--> ethernetline <--> routerB2.ethg++;
        }

        for i=0..numIoT-1 {
            iot0[i].ethg++ <--> ethernetline <--> routerB0.ethg++;
        }
        routerB0.ethg++ <--> ethernetline <--> serverB0.ethg++;
        for i=0..numIoT-1 {
            iot1[i].ethg++ <--> ethernetline <--> routerB1.ethg++;
        }
        routerB1.ethg++ <--> ethernetline <--> serverB1.ethg++;
        for i=0..numIoT-1 {
            iot2[i].ethg++ <--> ethernetline <--> routerB2.ethg++;
        }
        routerB2.ethg++ <--> ethernetline <--> serverB2.ethg++;
        routerB0.ethg++ <--> ethernetline <--> routerA.ethg++;
        routerB1.ethg++ <--> ethernetline <--> routerA.ethg++;
        routerB2.ethg++ <--> ethernetline <--> routerA.ethg++;
        routerA.ethg++ <--> ethernetline <--> serverA.ethg++;
}

//
//
// Clients and multiple servers
//
//
network newMultiTiered
{
    parameters:
        double numBServers @prompt("Number of child servers") = default(1);
        @display("bgb=1000,600;bgl=4");
    submodules:
        configurator: IPv4NetworkConfigurator {
            parameters:
                //                moduleTypes = "Router StandardHost";
                //                nonIPModuleTypes = "";
                @display("p=58,79;i=block/cogwheel");
        }
        controller: HttpController {
            parameters:
                @display("p=62,156;i=block/cogwheel");
        }
        serverA: StandardHost {
            parameters:
                @display("p=232.17499,189.50499;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerA: Router {
            parameters:
                @display("p=371.47998,189.50499;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        routerB[numBServers]: Router {
            parameters:
                @display("p=371.47998,392.815;i=abstract/router_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
        serverB[numBServers]: StandardHost {
            parameters:
                @display("p=175.7,392.815;i=device/server_l");
                @statistic[hopCount](title="hop count"; source="arrival"; record=vector,stats; interpolationmode=none);
        }
    connections:
        for i=0..numBServers-1 {
            routerB[i].ethg++ <--> ethernetline <--> routerA.ethg++;
            routerB[i].ethg++ <--> ethernetline <--> serverB[i].ethg++;
        }
        serverA.ethg++ <--> ethernetline <--> routerA.ethg++;
}
