#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОснованиеДляПечати

&ИзменениеИКонтроль("СтруктураОснованияДляПечати")
Функция бг_СтруктураОснованияДляПечати(Объект)

	СтруктураОснования = СтруктураОснования(Объект);

#Удаление
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Договор, "Дата, Номер");
	КонецЕсли;

	ТекстОснование = "";
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
		
		Если ЗначениеЗаполнено(Объект.Договор) Тогда
			ТекстОснование = НСтр("ru = 'в переработку на давальческой основе по договору №%1 от %2';
			|en = 'subcontracting services under agreement No.%1, %2'");
			ТекстОснование = СтрШаблон(
			ТекстОснование,
			Строка(РеквизитыДоговора.Номер),
			Формат(РеквизитыДоговора.Дата, "ДЛФ=DD"));

		Иначе
			ТекстОснование = НСтр("ru = 'в переработку на давальческой основе';
			|en = 'To tolling'");
		КонецЕсли;

		ТекстОснование = СтруктураОснования.Основание + ", " + ТекстОснование;

	Иначе

		Если ЗначениеЗаполнено(Объект.Договор) Тогда
			ТекстОснование = НСтр("ru = 'В переработку на давальческой основе по договору №%1 от %2';
			|en = 'subcontracting services under agreement No.%1, %2'");
			ТекстОснование = СтрШаблон(
			ТекстОснование,
			Строка(РеквизитыДоговора.Номер),
			Формат(РеквизитыДоговора.Дата, "ДЛФ=DD"));
		Иначе
			ТекстОснование = НСтр("ru = 'В переработку на давальческой основе';
			|en = 'To tolling'");
		КонецЕсли;

	КонецЕсли;

	СтруктураОснования.Основание = ТекстОснование;
#КонецУдаления

	Возврат СтруктураОснования;

КонецФункции

&ИзменениеИКонтроль("ТаблицаОснованийДляПечати")
Функция бг_ТаблицаОснованийДляПечати(Объект)

	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Договор, "Дата, Номер");
	КонецЕсли;

	ТаблицаОснований = Новый ТаблицаЗначений;
	ТаблицаОснований.Колонки.Добавить("Основание",      Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(300)));
	ТаблицаОснований.Колонки.Добавить("ОснованиеДата",  Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата))); 
	ТаблицаОснований.Колонки.Добавить("ОснованиеНомер", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(128)));

	СтруктураОснования = СтруктураОснования(Объект, Истина);
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
#Удаление
		Если ЗначениеЗаполнено(Объект.Договор) Тогда
			СтруктураОснования.Основание = 
			СтруктураОснования.Основание 
			+ ", " 
			+ СтрШаблон(НСтр("ru = 'в переработку на давальческой основе по договору №%1 от %2';
			|en = 'subcontracting services under agreement No.%1, %2'"), 
			Строка(РеквизитыДоговора.Номер), 
			Формат(РеквизитыДоговора.Дата, "ДЛФ=DD"));
		Иначе
			СтруктураОснования.Основание = 
			СтруктураОснования.Основание 
			+ ", " 
			+ НСтр("ru = 'в переработку на давальческой основе';
			|en = 'to tolling'");
		КонецЕсли; 
#КонецУдаления

		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
	КонецЕсли;

	СтруктураОснования = СтруктураОснования(Объект, Ложь);
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда

#Удаление
		Если ТаблицаОснований.Количество() = 0 Тогда
			Если ЗначениеЗаполнено(Объект.Договор) Тогда
				СтруктураОснования.Основание = СтруктураОснования.Основание 
				+ ", " 
				+ СтрШаблон(НСтр("ru = 'в переработку на давальческой основе по договору №%1 от %2';
				|en = 'subcontracting services under agreement No.%1, %2'"), 
				Строка(РеквизитыДоговора.Номер), 
				Формат(РеквизитыДоговора.Дата, "ДЛФ=DD"));
			Иначе
				СтруктураОснования.Основание = СтруктураОснования.Основание 
				+ ", " 
				+ НСтр("ru = 'в переработку на давальческой основе';
				|en = 'to tolling'");
			КонецЕсли;
		КонецЕсли;
#КонецУдаления
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);

	КонецЕсли;

	Если ТаблицаОснований.Количество() = 0 Тогда
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
#Удаление
		Если ЗначениеЗаполнено(Объект.Договор) Тогда
			ДобавленнаяСтрока.Основание = СтрШаблон(НСтр("ru = 'В переработку на давальческой основе по договору №%1 от %2';
			|en = 'subcontracting services under agreement No.%1, %2'"), 
			Строка(РеквизитыДоговора.Номер), 
			Формат(РеквизитыДоговора.Дата, "ДЛФ=DD"));
		Иначе
			ДобавленнаяСтрока.Основание = НСтр("ru = 'В переработку на давальческой основе';
			|en = 'To tolling'");
		КонецЕсли;
#КонецУдаления

		ДобавленнаяСтрока.ОснованиеДата = ?(ЗначениеЗаполнено(Объект.Договор), РеквизитыДоговора.Дата, ""); 
		ДобавленнаяСтрока.ОснованиеНомер = ?(ЗначениеЗаполнено(Объект.Договор), ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыДоговора.Номер), ""); 
	КонецЕсли;

	Возврат ТаблицаОснований;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
