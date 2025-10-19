#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"

// Define o namespace
using namespace ns3;

// Ativa a geração de logs
NS_LOG_COMPONENT_DEFINE ("HelloSimulator");

int main (int argc, char *argv[])
{
  // Configura a precisão do tempo de simulação
  Time::SetResolution (Time::NS);
  
  // Ativa a geração de logs para PointToPointNetDevice (opcional)
  LogComponentEnable ("PointToPointNetDevice", LOG_LEVEL_INFO);
  
  // 1. Cria os nós (nodes)
  NodeContainer nodes;
  nodes.Create (2);

  // 2. Cria e configura o canal Ponto-a-Ponto (Point-to-Point)
  PointToPointHelper pointToPoint;
  pointToPoint.SetDeviceAttribute ("DataRate", StringValue ("5Mbps"));
  pointToPoint.SetChannelAttribute ("Delay", StringValue ("2ms"));

  // 3. Instala os dispositivos (devices) nos nós
  NetDeviceContainer devices;
  devices = pointToPoint.Install (nodes);

  // 4. Instala a pilha de protocolos de internet (IP, TCP, UDP, etc.)
  InternetStackHelper stack;
  stack.Install (nodes);

  // 5. Atribui endereços IP
  Ipv4AddressHelper address;
  address.SetBase ("10.1.1.0", "255.255.255.0");
  Ipv4InterfaceContainer interfaces = address.Assign (devices);

  // 6. Configura uma aplicação EchoServer no nó 1
  UdpEchoServerHelper echoServer (9);
  ApplicationContainer serverApps = echoServer.Install (nodes.Get (1));
  serverApps.Start (Seconds (1.0));
  serverApps.Stop (Seconds (10.0));

  // 7. Configura uma aplicação EchoClient no nó 0
  UdpEchoClientHelper echoClient (interfaces.GetAddress (1), 9);
  echoClient.SetAttribute ("MaxPackets", UintegerValue (1));
  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient.SetAttribute ("PacketSize", UintegerValue (1024));
  ApplicationContainer clientApps = echoClient.Install (nodes.Get (0));
  clientApps.Start (Seconds (2.0));
  clientApps.Stop (Seconds (10.0));

  // 8. Inicia a simulação
  NS_LOG_INFO ("Iniciando a simulação.");
  Simulator::Run ();
  Simulator::Destroy ();
  NS_LOG_INFO ("Simulação terminada.");

  return 0;
}