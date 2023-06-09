#Область ПрограммныйИнтерфейс

Функция ЭтоТТНИсходящаяПоЭкспорту(ТТНИсходящаяЕГАИС) Экспорт

	Возврат Документы.ТТНИсходящаяЕГАИС.бг_ЭтоТТНИсходящаяПоЭкспорту(ТТНИсходящаяЕГАИС);

КонецФункции

Функция ЕстьАлкогольнаяПродукция(ДокументСсылка) Экспорт

	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
 		Возврат бг_Номенклатура.ЕстьМаркируемаяАлкогольнаяПродукцияВДокументе(ДокументСсылка, "Товары", Ложь);
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
		Возврат бг_Номенклатура.ЕстьМаркируемаяАлкогольнаяПродукцияВДокументе(ДокументСсылка, "Товары", Ложь);		
	Иначе
		Возврат Ложь;
	КонецЕсли;	

КонецФункции

Функция ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка) Экспорт
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
		Возврат Документы.АктПостановкиНаБалансЕГАИС.бг_ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка);
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.АктСписанияЕГАИС") Тогда
		Возврат Документы.АктСписанияЕГАИС.бг_ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка);
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
		Возврат Документы.ВозвратТоваровОтКлиента.бг_ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка);
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		Возврат Документы.ПриобретениеТоваровУслуг.бг_ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка);
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		Возврат Документы.ТТНВходящаяЕГАИС.бг_ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка);
	ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС") Тогда
		Возврат Документы.ТТНИсходящаяЕГАИС.бг_ЕстьМаркируемаяАлкогольнаяПродукция(ДокументСсылка);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ИспользоватьМеханизмДвиженийМарок(Документ, ДокументОснование = Неопределено) Экспорт
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
		Возврат Документы.АктПостановкиНаБалансЕГАИС.бг_ИспользоватьМеханизмДвиженийМарок(Документ);
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.АктСписанияЕГАИС") Тогда
		Возврат Документы.АктСписанияЕГАИС.бг_ИспользоватьМеханизмДвиженийМарок(Документ);
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		Возврат Документы.ТТНВходящаяЕГАИС.бг_ИспользоватьМеханизмДвиженийМарок(Документ);
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ТТНИсходящаяЕГАИС") Тогда
		Возврат Документы.ТТНИсходящаяЕГАИС.бг_ИспользоватьМеханизмДвиженийМарок(Документ, ДокументОснование);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
