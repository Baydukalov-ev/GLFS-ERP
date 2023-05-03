
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура(
						"Отбор", 
						Новый Структура(
							"ПунктНазначения", 
							ПараметрыВыполненияКоманды.Источник.Объект.Ссылка));
	
	ОткрытьФорму(
		"РегистрСведений.бг_ЛицензииПунктовНазначения.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти