#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ)
	Если Отказ Или ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(бг_ДатаНачисленияАкциза) И ЗначениеЗаполнено(Справка1) Тогда
		ДанныеСправки1 = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Справка1, 
			"бг_ДатаГТД, ДатаТТН, бг_НомерГТД.СтранаПроисхождения.УчастникЕАЭС");
		                                      
		Если ДанныеСправки1.бг_НомерГТДСтранаПроисхожденияУчастникЕАЭС = Истина Тогда
			бг_ДатаНачисленияАкциза = ДанныеСправки1.ДатаТТН;
		Иначе 
			бг_ДатаНачисленияАкциза = ДанныеСправки1.бг_ДатаГТД;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
