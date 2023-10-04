//
//  MissionView.swift
//  Moonshot
//
//  Created by Aaron Brown on 10/2/23.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
        
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width * 0.6)
                        .padding(.top)
                    VStack(alignment: .leading) {
                        Divider()
                        Text("Mission HighLights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        Text(mission.description)
                        Divider()
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack {
                            ForEach(crew, id: \.role) { crewMember in
                                NavigationLink {
                                    AstronautView(astronaut: crewMember.astronaut)
                                } label: {
                                    HStack {
                                        Image(crewMember.astronaut.id)
                                            .resizable()
                                            .frame(width: 104, height: 72)
                                            .clipShape(Circle())
                                            .overlay {
                                                Circle()
                                                    .strokeBorder(.white, lineWidth: 1)
                                            }
                                        VStack(alignment: .leading) {
                                            Text(crewMember.astronaut.name)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                            Text(crewMember.role)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronaut: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            
            if let astronaut = astronaut[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(astronaut) from data")
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronaut: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronaut: astronaut)
            .preferredColorScheme(.dark)
    }
}
