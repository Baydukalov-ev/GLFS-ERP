 
 #Область ОбработчикиСобытий
 
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"РегистрСведений.ЗаданияКФормированиюДвиженийПоНДС.Форма.ВыполнениеЗаданийРасчета",, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
	
#КонецОбласти
