#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(бг_НомерДокументаУПП) Тогда
		Номер = бг_НомерДокументаУПП;
		ПредставлениеНомера = бг_НомерДокументаУПП;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("АктуализироватьДатуВыставленияСФ")
		И ЗначениеЗаполнено(ДатаВыставления) Тогда
		ДатаВыставления = Дата;
	КонецЕсли;
	Если ДополнительныеСвойства.Свойство("адаптер_ЭтоЗагрузкаДанных") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&После("ПриКопировании")
Процедура бг_ПриКопировании(ОбъектКопирования)
	
	бг_НомерДокументаУПП = "";
	ПредставлениеНомера = "";
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура бг_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	бг_ЗаполнитьОтветственных(ДанныеЗаполнения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура бг_ЗаполнитьОтветственных(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДокументОснование")
		И ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения.ДокументОснование,
			"Руководитель, ГлавныйБухгалтер");
		Руководитель = Реквизиты.Руководитель;
		ГлавныйБухгалтер = Реквизиты.ГлавныйБухгалтер;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Руководитель, ГлавныйБухгалтер");
		Руководитель = Реквизиты.Руководитель;
		ГлавныйБухгалтер = Реквизиты.ГлавныйБухгалтер;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
