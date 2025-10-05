;; BH_tomatos.clp - Base de Hechos (FuzzyCLIPS) - Formato Singleton

(reset)

(deffacts Entradas
    ;; Temperatura = 32 °C
    (FT (32 0) (32 1) (32 0)) 
    
    ;; HumedadSuelo = 35 %
    (FHS (35 0) (35 1) (35 0))
    
    ;; HumedadAire = 85 %
    (FHA (85 0) (85 1) (85 0))
)

(run)
(facts)