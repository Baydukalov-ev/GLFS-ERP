#Область ПрограммныйИнтерфейс

Функция КлючИсточникаЗагрузкиЗаказа(ИсточникЗагрузки) Экспорт
	
	ПостфиксКлючаМаршрутизации = "";
	
	Если Не ЗначениеЗаполнено(ИсточникЗагрузки) Тогда
		Возврат ПостфиксКлючаМаршрутизации;
	КонецЕсли;
	
	Если ИсточникЗагрузки = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.B2B Тогда
		ПостфиксКлючаМаршрутизации = "Source_В2B";
	ИначеЕсли ИсточникЗагрузки = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.PortalDistr Тогда
		ПостфиксКлючаМаршрутизации = "Source_PortalDistr";
	ИначеЕсли ИсточникЗагрузки = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.EDI Тогда
		ПостфиксКлючаМаршрутизации = "Source_EDI";
	ИначеЕсли ИсточникЗагрузки = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.Чикаго Тогда
		ПостфиксКлючаМаршрутизации = "Source_Chicago";
	КонецЕсли;
	
	Возврат ПостфиксКлючаМаршрутизации;
	
КонецФункции

Функция ИсточникЗагрузкиЗаказаПоНаименованию(НаименованиеИсточника) Экспорт
	
	МетаданныеПеречисления = Метаданные.Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов;
	МетаданныеЗначенияПеречисления = МетаданныеПеречисления.ЗначенияПеречисления.Найти(НаименованиеИсточника);
	Если МетаданныеЗначенияПеречисления <> Неопределено Тогда
		ИсточникЗаказа = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов[НаименованиеИсточника];
	Иначе
		ИсточникЗаказа = Перечисления.бг_ИсточникиЗагрузкиЗаказовКлиентов.ПустаяСсылка();
	КонецЕсли;

	Возврат ИсточникЗаказа;
	
КонецФункции

#КонецОбласти
