
Процедура ПередЗаписью(Отказ, Замещение)
	
	Идентификатор = Отбор.Найти("Идентификатор").Значение; 
	Для Каждого ТекущаяСтрока Из ЭтотОбъект Цикл
		ТекущаяСтрока.Идентификатор = Идентификатор;
	КонецЦикла;
	
КонецПроцедуры
