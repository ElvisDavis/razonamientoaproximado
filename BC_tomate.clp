;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BC_tomato.clp - Base de Conocimientos (FuzzyCLIPS, Mamdani)
;; Dominio: Control de invernadero de tomate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ------------- Definición de universos y términos borrosos -------------
(deftemplate Temperatura
  10 45 ; <-- Se eliminó 'celsius' para evitar el error [PRNUTIL2]
  ((Baja  (10 1) (18 1) (22 0))
   (Media (18 0) (25 1) (32 0))
   (Alta  (28 0) (35 1) (45 1))))

(deftemplate HumedadSuelo
  0 100
  ((Seca   (0 1) (0 1) (30 0))
   (Media  (20 0) (45 1) (70 0))
   (Humeda (60 0) (100 1) (100 1))))

(deftemplate HumedadAire
  30 100
  ((Baja  (30 1) (40 1) (60 0))
   (Media (50 0) (70 1) (85 0))
   (Alta  (80 0) (100 1) (100 1))))

(deftemplate Riego
  0 100
  ((Nulo  (0 1) (0 1) (10 0))
   (Bajo  (10 0) (30 1) (50 0))
   (Medio (40 0) (60 1) (80 0))
   (Alto  (70 0) (90 1) (100 1))))

(deftemplate Ventilacion
  0 100
  ((Nula  (0 1) (0 1) (10 0))
   (Baja  (10 0) (30 1) (50 0))
   (Media (40 0) (60 1) (80 0))
   (Alta  (70 0) (90 1) (100 1))))

; ------------- Reglas (10) -------------
(defrule R1
  (HumedadSuelo Seca)
  (Temperatura Alta)
  =>
  (assert (Riego Alto))
  (assert (Ventilacion Media)))

(defrule R2
  (HumedadSuelo Seca)
  (Temperatura Media)
  =>
  (assert (Riego Medio)))

(defrule R3
  (HumedadSuelo Seca)
  (HumedadAire Baja)
  =>
  (assert (Riego Medio)))

(defrule R4
  (HumedadSuelo Humeda)
  =>
  (assert (Riego Nulo)))

(defrule R5
  (HumedadAire Alta)
  (HumedadSuelo Humeda)
  =>
  (assert (Riego Nulo))
  (assert (Ventilacion Baja)))

(defrule R6
  (HumedadAire Alta)
  (Temperatura Alta)
  =>
  (assert (Ventilacion Alta)))

(defrule R7
  (Temperatura Media)
  (HumedadAire Media)
  =>
  (assert (Ventilacion Media)))

(defrule R8
  (Temperatura Baja)
  =>
  (assert (Ventilacion Nula)))

(defrule R9
  (HumedadSuelo Media)
  (HumedadAire Baja)
  =>
  (assert (Riego Bajo)))

(defrule R10
  (HumedadAire Alta)
  (HumedadSuelo Seca)
  =>
  (assert (Riego Bajo)))

; ------------- Defuzzificación (centroide) -------------
(defrule Defuzz_Riego
  (declare (salience -5))
  ?r <- (Riego ?)
  =>
  (bind ?val (moment-defuzzify ?r))
  (printout t crlf ">> RIEGO recomendado (centroide): " ?val crlf))

(defrule Defuzz_Vent
  (declare (salience -6))
  ?v <- (Ventilacion ?)
  =>
  (bind ?val (moment-defuzzify ?v)) ; <-- Corregido
  (printout t ">> VENTILACION recomendada (centroide): " ?val crlf))