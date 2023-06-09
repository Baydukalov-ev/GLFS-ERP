#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// ДопАналитика не должна хранить пустых ссылок 
	Если ЭтотОбъект.Количество() > 0
		И Отбор.Найти("ДопАналитика") <> Неопределено Тогда
		ДопАналитика = Отбор.ДопАналитика.Значение;
		Если Не ЗначениеЗаполнено(ДопАналитика)
			И ДопАналитика <> Неопределено Тогда
			Отбор.ДопАналитика.Значение = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Запись.ДопАналитика) Тогда
			Если Запись.ДопАналитика <> Неопределено Тогда
				Запись.ДопАналитика = Неопределено;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(Запись.КаналПродаж)
			Или ЗначениеЗаполнено(Запись.Территория) Тогда
			Отказ = Истина;
			ТекстОшибки = НСтр("ru = 'Нельзя использовать доп.аналитику вместе с каналом и территорией'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
			Возврат;				 
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти