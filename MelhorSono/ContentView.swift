//
//  ContentView.swift
//  MelhorSono
//
//  Created by Rodrigo Cavalcanti on 02/11/20.
//

import SwiftUI
struct ContentView: View {
    
    static var horárioPadrão: Date {
        var componente = DateComponents()
        componente.hour = 7
        componente.minute = 0
        return Calendar.current.date(from: componente) ?? Date()
    }
    
    @State private var horaSelecionada = horárioPadrão
    @State private var quantidadeSono = 8.0
    @State private var cafeSelecionado = 4
    @State private var alertaTitulo = ""
    @State private var alertaMensagem = ""
    @State private var mostrandoAlerta = false
    
    func calcular() {
        let modelo = Calcule()
        let componente = Calendar.current.dateComponents([.hour,.minute], from: horaSelecionada)
        let hora = (componente.hour ?? 0) * 60 * 60
        let minuto = (componente.minute ?? 0) * 60
        
        do {
            let previsão = try modelo.prediction(wake: Double(hora + minuto), sleepAmount: quantidadeSono, coffee: Double(cafeSelecionado))
            
            let horaDeDormir = horaSelecionada - previsão.actualSleep
            
            let formatador = DateFormatter()
            formatador.timeStyle = .short
            
            alertaTitulo = "O horário de dormir ideal é"
            alertaMensagem = formatador.string(from: horaDeDormir)
            
        } catch {
            alertaTitulo = "Erro"
            alertaMensagem = "Não foi possível calcular o horário de dormir deal"
        }
        mostrandoAlerta = true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quando você quer acordar?")
                            .font(.headline)) {
                    DatePicker("Escolha o horário de acordar", selection: $horaSelecionada, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Por quanto tempo você quer dormir?").font(.headline)) {
                    Stepper(value: $quantidadeSono, in: 4...12, step: 0.25) {
                        Text("\(quantidadeSono, specifier: "%g") horas")
                    }
                }
                
                Section(header: Text("Qual é o seu consumo diário de café?").font(.headline)) {
                    Picker("Selecione", selection: $cafeSelecionado) {
                        ForEach(1...20, id: \.self) {
                            Text("\($0) copo\($0 > 1 ? "s":"")")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationBarTitle("MelhorSono")
            .navigationBarItems(trailing: Button("Calcular", action: calcular))
            .alert(isPresented: $mostrandoAlerta) {
                Alert(title: Text(alertaTitulo), message: Text(alertaMensagem), dismissButton: .default(Text("Continuar")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
