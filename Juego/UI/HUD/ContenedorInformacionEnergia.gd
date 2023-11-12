class_name ContenedorInformacionEnergia

extends ContenedorInformacion

onready var medidor:ProgressBar = $ProgressBar

func actualizar_energia(energia_max:float, energia_actual:float) ->void:
	var energia_porcent:int = (energia_actual *100) / energia_max
	medidor.value = energia_porcent
