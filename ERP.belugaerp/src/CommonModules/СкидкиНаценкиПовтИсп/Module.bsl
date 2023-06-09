
#Область ПрограммныйИнтерфейс

Функция бг_НакоплениеСкидкиДоступно(СпособПримененияСкидки, СпособПредоставления) Экспорт
	
	СпособыПредоставления = Новый Массив;
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.Процент"));
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.Сумма"));
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.СуммаДляКаждойСтроки"));
	
	Возврат бг_СвойствоДоступно(СпособПримененияСкидки, СпособПредоставления, СпособыПредоставления, "Накопительная");
	
КонецФункции

Функция бг_ОграничениеСкидкиДоступно(СпособПримененияСкидки, СпособПредоставления) Экспорт
	
	СпособыПредоставления = Новый Массив;
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.Процент"));
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.ВидЦены"));
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.Сумма"));
	СпособыПредоставления.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПредоставленияСкидокНаценок.СуммаДляКаждойСтроки"));
	
	Возврат бг_СвойствоДоступно(СпособПримененияСкидки, СпособПредоставления, СпособыПредоставления, "Ограничивается");
	
КонецФункции

Функция бг_ИмяПоляЦеновойГруппы(ИсточникГруппы) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИсточникГруппы) Тогда
		Возврат "";
	КонецЕсли;
	
	НастройкаПоля = Перечисления.бг_ИсточникиЦеновойГруппы.НастройкиПолейЗапроса()[ИсточникГруппы];
	Если НЕ ЗначениеЗаполнено(ИсточникГруппы) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат НастройкаПоля.Имя;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция бг_СвойствоДоступно(СпособПримененияСкидки, СпособПредоставления, ПодходящиеСпособы, ИмяСвойстваДопОбработки = "")
	
	СвойствоДоступно = Ложь;
	
	Если СпособПримененияСкидки = ПредопределенноеЗначение("Перечисление.СпособыПримененияСкидокНаценок.ПрименитьВМоментРасчетаСкидокНаценок")
		И ЗначениеЗаполнено(СпособПредоставления) Тогда
		
		Если ПодходящиеСпособы.Найти(СпособПредоставления) <> Неопределено Тогда
			
			СвойствоДоступно = Истина;
			
		ИначеЕсли ТипЗнч(СпособПредоставления) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки")
			И НЕ ПустаяСтрока(ИмяСвойстваДопОбработки) Тогда
			
			СведенияОбОбработке = СкидкиНаценкиПовтИсп.ОбъектВнешнейОбработки(СпособПредоставления).СведенияОВнешнейОбработке();
			Если СведенияОбОбработке.Свойство(ИмяСвойстваДопОбработки) Тогда
				
				СвойствоДоступно = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СвойствоДоступно;
	
КонецФункции

#КонецОбласти
